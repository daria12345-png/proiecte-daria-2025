#!/bin/bash

# creeaza directoarele pentru salvarea logurilor (daca nu exista)
init_directories() {
    mkdir -p "$SYSLOG_DIR"
    mkdir -p "$AUTHLOG_DIR"
    mkdir -p "$APTLOG_DIR"
    mkdir -p "$CUSTOM_DIR"
    mkdir -p "$APACHE_DIR"
    mkdir -p "$NGINX_DIR"
    mkdir -p "$LOG_SAVE_DIR/cron"
}

# copiaza un log in directorul potrivit, in functie de nume
copy_log() {
    local filepath="$1"

    if [ ! -f "$filepath" ]; then
        echo "[!] Logul $filepath nu exista sau nu poate fi citit."
        return
    fi

    local filename
    filename=$(basename "$filepath")

    # determinam in ce director il punem
    case "$filepath" in
        *syslog*) cp "$filepath" "$SYSLOG_DIR/$filename" ;;
        *auth*) cp "$filepath" "$AUTHLOG_DIR/$filename" ;;
        *apt*) cp "$filepath" "$APTLOG_DIR/$filename" ;;
        *) cp "$filepath" "$CUSTOM_DIR/$filename" ;;
    esac
}

# filtrare activitate CRON (universal pentru Ubuntu + Fedora)
filter_cron_activity() {
    echo "[*] Filtrare activitate CRON..."
    local cron_log="$LOG_SAVE_DIR/cron/cron_activity.log"
    > "$cron_log"

    find "$LOG_SAVE_DIR" -type f ! -path "*/cron/*" | while read -r file; do
        grep -i "cron" "$file" >> "$cron_log"
    done
}

