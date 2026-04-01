#!/bin/zsh

set -u

typeset -a scan_dirs top_level_apps
scan_dirs=(/Applications "$HOME/Applications")

show_paths=0

usage() {
  cat <<'EOF'
Usage:
  detect_chromium_apps.zsh [--scan-dir DIR] [--show-paths]

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

while (( $# > 0 )); do
  case "$1" in
    --scan-dir)
      if (( $# < 2 )); then
        print -u2 -- "Missing value for --scan-dir"
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
      print -u2 -- "Unknown argument: $1"
      usage >&2
      exit 1
      ;;
  esac
done

scan_dirs=("${(@u)scan_dirs}")

is_top_level_app_bundle() {
  local path="$1"
  local parent="${path:h}"

  while [[ "$parent" != "/" && "$parent" != "." && "$parent" != "$path" ]]; do
    if [[ "$parent" == *.app ]]; then
      return 1
    fi
    path="$parent"
    parent="${parent:h}"
  done

  return 0
}

add_unique() {
  local array_name="$1"
  local value="$2"
  local -a current_values
  local item

  eval "current_values=(\"\${${array_name}[@]}\")"
  for item in "${current_values[@]}"; do
    [[ "$item" == "$value" ]] && return 0
  done

  eval "$array_name+=(\"\$value\")"
}

reason_for_evidence() {
  local basename="$1:t"

  case "$basename" in
    Electron\ Framework.framework)
      print -- "Electron runtime"
      ;;
    Chromium\ Framework.framework|Chromium\ Embedded\ Framework.framework)
      print -- "Chromium framework"
      ;;
    Google\ Chrome\ Framework.framework|Microsoft\ Edge\ Framework.framework)
      print -- "Chromium browser framework"
      ;;
    QtWebEngineCore.framework|QtWebEngineProcess.app)
      print -- "QtWebEngine"
      ;;
    libcef.dylib)
      print -- "CEF library"
      ;;
    app.asar)
      print -- "Electron app bundle"
      ;;
    chrome_100_percent.pak|chrome_200_percent.pak|icudtl.dat|resources.pak|v8_context_snapshot.bin|snapshot_blob.bin)
      print -- "Chromium resources"
      ;;
    *)
      print -- "Chromium-family evidence"
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
  local -a rows=("$@")
  local underline

  (( ${#rows[@]} > 0 )) || return 0

  underline=$(printf '%*s' ${#title} '')
  underline=${underline// /-}

  print
  print -- "$title"
  print -- "$underline"
  printf '%s\n' "${rows[@]}"
}

for dir in "${scan_dirs[@]}"; do
  [[ -d "$dir" ]] || continue

  while IFS= read -r app; do
    is_top_level_app_bundle "$app" || continue
    add_unique top_level_apps "$app"
  done < <(find "$dir" -type d -name '*.app' 2>/dev/null | sort)
done

top_level_apps=("${(@o)top_level_apps}")

typeset -a top_rows nested_rows shim_rows
integer total=0 top_count=0 nested_count=0 shim_count=0

for app in "${top_level_apps[@]}"; do
  typeset -a direct_reasons=() nested_reasons=() direct_samples=() nested_samples=()
  local_bundle_id="$(bundle_id_for_app "$app")"
  local_executable="$(executable_for_app "$app")"

  while IFS= read -r hit; do
    [[ -n "$hit" ]] || continue

    rel_path="${hit#$app/}"
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
    (( total++ ))
    (( top_count++ ))
    label="${app:t}"
    if (( show_paths )); then
      label="$app"
    fi
    top_rows+=("- ${label} | reasons: ${(j:, :)direct_reasons} | evidence: ${(j:, :)direct_samples}")
    continue
  fi

  if (( ${#nested_reasons[@]} > 0 )); then
    (( total++ ))
    (( nested_count++ ))
    label="${app:t}"
    if (( show_paths )); then
      label="$app"
    fi
    nested_rows+=("- ${label} | reasons: ${(j:, :)nested_reasons} | evidence: ${(j:, :)nested_samples}")
    continue
  fi

  if (( is_chrome_shim )); then
    (( total++ ))
    (( shim_count++ ))
    label="${app:t}"
    if (( show_paths )); then
      label="$app"
    fi
    shim_rows+=("- ${label} | reasons: Chrome app shim | bundle id: ${local_bundle_id}")
  fi
done

print -- "Detected ${total} macOS app bundle(s) with Chromium-family evidence."
print -- "  Top-level runtime: ${top_count}"
print -- "  Nested runtime:    ${nested_count}"
print -- "  Chrome app shim:   ${shim_count}"

print_section "Top-level runtime" "${top_rows[@]}"
print_section "Nested runtime" "${nested_rows[@]}"
print_section "Chrome app shim" "${shim_rows[@]}"
