#!/bin/bash

# filtrare loguri dupa data (simplificat: caută linii care contin luna si ziua intre limite)
filter_logs_by_date() {
    local from_date="$1"   # format: YYYY-MM-DD
    local to_date="$2"     # format: YYYY-MM-DD

    echo "[*] Filtrare după data: $from_date → $to_date"

    # Convertim in secunde
    from_ts=$(date -d "$from_date" +%s)
    to_ts=$(date -d "$to_date" +%s)

    # parcurgem toate fisierele din logs/
    find "$LOG_SAVE_DIR" -type f ! -name "*.filtered" ! -name "journal_dump.txt" ! -name "wtmp_parsed.txt" | while read -r file; do
        output="$file.filtered"
        while read -r line; do
            # extragem data din linie (doar pentru formate gen: Jul 17 ...)
            if [[ "$line" =~ ^([A-Z][a-z]{2})[[:space:]]+([0-9]{1,2}) ]]; then
                month="${BASH_REMATCH[1]}"
                day="${BASH_REMATCH[2]}"
                year=$(date +%Y)
                full_date=$(date -d "$month $day $year" +%Y-%m-%d 2>/dev/null)
                line_ts=$(date -d "$full_date" +%s 2>/dev/null)

                if [ "$line_ts" -ge "$from_ts" ] && [ "$line_ts" -le "$to_ts" ]; then
                    echo "$line" >> "$output"
                fi
            fi
        done < "$file"
    done
}

# Filtrare loguri dupa nivel de severitate (error, warning, etc)
filter_logs_by_severity() {
    local level="$1"
    echo "[*] Filtrare dupa severitate: $level"
    mkdir -p "$LOG_SAVE_DIR/filtered"

    local temp_file="$LOG_SAVE_DIR/filtered/severity_${level}.tmp"
    local final_file="$LOG_SAVE_DIR/filtered/severity_${level}.log"

    > "$temp_file"
    find "$LOG_SAVE_DIR" -type f ! -name "*.log" ! -name "*.tmp" ! -path "*/filtered/*" | while read -r file; do
        grep -I -i "$level" "$file" >> "$temp_file"
    done

    mv "$temp_file" "$final_file"
}
