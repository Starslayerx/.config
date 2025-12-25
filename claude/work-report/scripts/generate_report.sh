#! /opt/homebrew/bin/bash

set -euo pipefail

parse_date_range() {
    local param="${1:-today}"
    local start_date end_date

    case "$param" in 
        today)
            # today 00:00 to tomorrow 00:00
            start_date=$(date +%F)
            end_date=$(date -j -v+1d -f "%Y-%m-%d" "$start_date" "+%Y-%m-%d")
            ;;

        yesterday)
            # yesterday 00:00 to today 00:00
            start_date=$(date -j -v-1d +%F)
            end_date=$(date +%F)
            ;;

        thisweek)
            # This Monday 00:00 to today 00:00
            local day_of_week=$(date +%u)
            local days_since_monday=$((day_of_week - 1))
            start_date=$(date -j -v-${days_since_monday}d +%F)
            end_date=$(date -j -v+1d +%F)
            ;;

        lastweek)
            # Last Monday 00:00 to Last Sunday 24:00
            local day_of_week=$(date +%u)
            local days_to_last_monday=$((day_of_week + 6))  # last Monday
            start_date=$(date -j -v-${days_to_last_monday}d +%F)
            end_date=$(date -j -v-$((day_of_week - 1))d +%F)  # this Monday
            ;;

        thismonth)
            # This month 1st 00:00 to tomorrow 00:00
            start_date=$(date +%Y-%m-01)
            end_date=$(date -j -v+1d +%F)
            ;;

        lastmonth)
            # Last month 1st 00:00 to this month 00:00
            start_date=$(date -j -v-1m +%Y-%m-01)
            end_date=$(date +%Y-%m-01)
            ;;
        *)

            # Handle date YYYY-MM-DD
            if [[ "$param" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
                start_date="$param"
                # Check second param
                if [[ -n "${2:-}" ]]; then
                    end_date=$(date -j -v+1d -f "%Y-%m-%d" "$2" "+%Y-%m-%d")
                else
                    end_date=$(date -j -v+1d -f "%Y-%m-%d" "$start_date" "+%Y-%m-%d")
                fi
            else
                echo "Error: Not supported argument '$param'" >&2
                exit 1
            fi
            ;;
    esac
    echo "$start_date $end_date"
}

generate_report() {
    local start_date="$1"
    local end_date="$2"
    local author="$(git config user.name)"
    local current_date=""

    echo "- Author: $author"

    git log \
        --since="$start_date 00:00:00" \
        --until="$end_date 00:00:00" \
        --author="$author" \
        --no-merges \
        --pretty=format:'%h|%ad|%s' \
        --date=short |
    while IFS="|" read -r id date message; do
        # Check if date changed
        if [[ "$date" != "$current_date" ]]; then
            current_date="$date"
            # Output empty line if it's not first sheet
            [[ -n "$current_date" ]] && echo

            # Output sheet head
            echo "- Date: $date"
            echo
            echo "| Commit ID | Message |"
            echo "| :-------- | :------ |"
        fi
        # Output commit message
        echo "| $id | $message |"
    done
}

main() {
    # Get date range
    local dates
    dates=$(parse_date_range "${1:-today}" "${2:-}")
    # Break two date
    read -r start_date end_date <<< "$dates"
    # Generate a report
    generate_report "$start_date" "$end_date"
}

# Pass command line parameters
main "$@"
