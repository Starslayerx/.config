#!/usr/bin/env bash

set -u

scan_dirs=("/Applications" "$HOME/Applications")
top_level_apps=()
top_rows=()
nested_rows=()
shim_rows=()
show_paths=0

usage() {
  cat <<'EOF'
Usage:
  detect_chromium_apps.sh [--scan-dir DIR] [--show-paths]

What it detects:
  - Electron apps
  - Chromium / CEF based apps
  - QtWebEngine based apps
  - Chrome app shims created by Google Chrome

Notes:
  - The script scans top-level .app bundles under /Applications and ~/Applications by default.
  - It ignores helper apps when counting, but it can still detect Chromium runtimes nested inside a parent app.
EOF
}

add_unique() {
  local array_name="$1"
  local value="$2"
  local current_values=()
  local item

  eval "current_values=(\"\${${array_name}[@]}\")"
  for item in "${current_values[@]}"; do
    [[ "$item" == "$value" ]] && return 0
  done

  eval "$array_name+=(\"\$value\")"
}

join_by() {
  local delimiter="$1"
  shift
  local first=1
  local item

  for item in "$@"; do
    if (( first )); then
      printf '%s' "$item"
      first=0
    else
      printf '%s%s' "$delimiter" "$item"
    fi
  done
}

is_top_level_app_bundle() {
  local path="$1"
  local parent

  parent="$(dirname "$path")"
  while [[ "$parent" != "/" && "$parent" != "." && "$parent" != "$path" ]]; do
    if [[ "$parent" == *.app ]]; then
      return 1
    fi
    path="$parent"
    parent="$(dirname "$parent")"
  done

  return 0
}

reason_for_evidence() {
  local hit="$1"
  local name
  name="$(basename "$hit")"

  case "$name" in
    "Electron Framework.framework")
      printf '%s\n' "Electron runtime"
      ;;
    "Chromium Framework.framework"|"Chromium Embedded Framework.framework")
      printf '%s\n' "Chromium framework"
      ;;
    "Google Chrome Framework.framework"|"Microsoft Edge Framework.framework")
      printf '%s\n' "Chromium browser framework"
      ;;
    "QtWebEngineCore.framework"|"QtWebEngineProcess.app")
      printf '%s\n' "QtWebEngine"
      ;;
    "libcef.dylib")
      printf '%s\n' "CEF library"
      ;;
    "app.asar")
      printf '%s\n' "Electron app bundle"
      ;;
    "chrome_100_percent.pak"|"chrome_200_percent.pak"|"icudtl.dat"|"resources.pak"|"v8_context_snapshot.bin"|"snapshot_blob.bin")
      printf '%s\n' "Chromium resources"
      ;;
    *)
      printf '%s\n' "Chromium-family evidence"
      ;;
  esac
}

collect_evidence() {
  local root="$1"

  find "$root" -maxdepth 8 \
    \( \
      -name 'Electron Framework.framework' -o \
      -name 'Chromium Framework.framework' -o \
      -name 'Chromium Embedded Framework.framework' -o \
      -name '*Chrome Framework.framework' -o \
      -name '*Edge Framework.framework' -o \
      -name 'QtWebEngineCore.framework' -o \
      -name 'QtWebEngineProcess.app' -o \
      -name 'libcef.dylib' -o \
      -name 'app.asar' -o \
      -name 'icudtl.dat' -o \
      -name 'v8_context_snapshot.bin' -o \
      -name 'snapshot_blob.bin' -o \
      -name 'chrome_100_percent.pak' -o \
      -name 'chrome_200_percent.pak' -o \
      -name 'resources.pak' \
    \) -print 2>/dev/null | sort -u
}

bundle_id_for_app() {
  local app="$1"
  local plist="$app/Contents/Info.plist"

  [[ -f "$plist" ]] || return 0
  /usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$plist" 2>/dev/null || true
}

executable_for_app() {
  local app="$1"
  local plist="$app/Contents/Info.plist"

  [[ -f "$plist" ]] || return 0
  /usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$plist" 2>/dev/null || true
}

print_section() {
  local title="$1"
  shift
  local rows=("$@")
  local underline

  (( ${#rows[@]} > 0 )) || return 0

  printf -v underline '%*s' "${#title}" ''
  underline=${underline// /-}

  printf '\n%s\n%s\n' "$title" "$underline"
  printf '%s\n' "${rows[@]}"
}

while (( $# > 0 )); do
  case "$1" in
    --scan-dir)
      if (( $# < 2 )); then
        printf '%s\n' "Missing value for --scan-dir" >&2
        exit 1
      fi
      scan_dirs+=("$2")
      shift 2
      ;;
    --show-paths)
      show_paths=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

deduped_scan_dirs=()
for dir in "${scan_dirs[@]}"; do
  add_unique deduped_scan_dirs "$dir"
done
scan_dirs=("${deduped_scan_dirs[@]}")

for dir in "${scan_dirs[@]}"; do
  [[ -d "$dir" ]] || continue

  while IFS= read -r app; do
    [[ -n "$app" ]] || continue
    is_top_level_app_bundle "$app" || continue
    add_unique top_level_apps "$app"
  done < <(find "$dir" -type d -name '*.app' 2>/dev/null | sort)
done

IFS=$'\n' top_level_apps=($(printf '%s\n' "${top_level_apps[@]}" | sort))
unset IFS

total=0
top_count=0
nested_count=0
shim_count=0

for app in "${top_level_apps[@]}"; do
  direct_reasons=()
  nested_reasons=()
  direct_samples=()
  nested_samples=()
  local_bundle_id="$(bundle_id_for_app "$app")"
  local_executable="$(executable_for_app "$app")"

  while IFS= read -r hit; do
    [[ -n "$hit" ]] || continue

    rel_path="${hit#"$app"/}"
    reason="$(reason_for_evidence "$hit")"

    if [[ "$rel_path" == *".app/Contents/"* ]]; then
      add_unique nested_reasons "$reason"
      if (( ${#nested_samples[@]} < 3 )); then
        nested_samples+=("$rel_path")
      fi
    else
      add_unique direct_reasons "$reason"
      if (( ${#direct_samples[@]} < 3 )); then
        direct_samples+=("$rel_path")
      fi
    fi
  done < <(collect_evidence "$app/Contents")

  is_chrome_shim=0
  if [[ "$local_executable" == "app_mode_loader" || "$local_bundle_id" == com.google.Chrome.app.* ]]; then
    is_chrome_shim=1
  fi

  if (( ${#direct_reasons[@]} > 0 )); then
    (( total += 1 ))
    (( top_count += 1 ))
    label="$(basename "$app")"
    if (( show_paths )); then
      label="$app"
    fi
    top_rows+=("- ${label} | reasons: $(join_by ', ' "${direct_reasons[@]}") | evidence: $(join_by ', ' "${direct_samples[@]}")")
    continue
  fi

  if (( ${#nested_reasons[@]} > 0 )); then
    (( total += 1 ))
    (( nested_count += 1 ))
    label="$(basename "$app")"
    if (( show_paths )); then
      label="$app"
    fi
    nested_rows+=("- ${label} | reasons: $(join_by ', ' "${nested_reasons[@]}") | evidence: $(join_by ', ' "${nested_samples[@]}")")
    continue
  fi

  if (( is_chrome_shim )); then
    (( total += 1 ))
    (( shim_count += 1 ))
    label="$(basename "$app")"
    if (( show_paths )); then
      label="$app"
    fi
    shim_rows+=("- ${label} | reasons: Chrome app shim | bundle id: ${local_bundle_id}")
  fi
done

printf 'Detected %s macOS app bundle(s) with Chromium-family evidence.\n' "$total"
printf '  Top-level runtime: %s\n' "$top_count"
printf '  Nested runtime:    %s\n' "$nested_count"
printf '  Chrome app shim:   %s\n' "$shim_count"

print_section "Top-level runtime" "${top_rows[@]}"
print_section "Nested runtime" "${nested_rows[@]}"
print_section "Chrome app shim" "${shim_rows[@]}"
