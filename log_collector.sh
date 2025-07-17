#!/bin/bash

# Directorul unde vom salva toate logurile
BACKUP_DIR="logs_backup"

# Fisier cu loguri suplimentare definite de utilizator
CONFIG_FILE="log_config.txt"

# Data pentru numele fisierelor
DATE=$(date +%Y-%m-%d_%H-%M)

# Creeaza folderul de backup daca nu exista
mkdir -p "$BACKUP_DIR"

echo "[INFO] Salvare loguri in: $BACKUP_DIR"

DISTRO=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
echo "[INFO] Distributie detectata: $DISTRO"

declare -a LOGS=()

if [[ "$DISTRO" == "ubuntu" || "$DISTRO" == "linuxmint" ]]; then
    LOGS+=("/var/log/syslog")
    LOGS+=("/var/log/auth.log")
    LOGS+=("/var/log/wtmp")
    LOGS+=("/var/log/apt/history.log")
    LOGS+=("/var/log/apt/term.log")
    LOGS+=("/var/log/journal")  # folder
elif [[ "$DISTRO" == "fedora" ]]; then
    LOGS+=("/var/log/messages")
    LOGS+=("/var/log/secure")
    LOGS+=("/var/log/wtmp")
    LOGS+=("/var/log/dnf.rpm.log")
    LOGS+=("/var/log/journal")
else
    echo "[WARN] Distributie necunoscuta. Se folosesc loguri implicite."
    LOGS+=("/var/log/syslog")
    LOGS+=("/var/log/auth.log")
    LOGS+=("/var/log/wtmp")
fi

if [[ -f "$CONFIG_FILE" ]]; then
    echo "[INFO] Se incarca loguri extra din $CONFIG_FILE"
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -n "$line" ]] && LOGS+=("$line")
    done < "$CONFIG_FILE"
else
    echo "[WARN] Fisier de configurare $CONFIG_FILE nu exista. Se continua fara loguri extra."
fi

for logfile in "${LOGS[@]}"; do
    if [[ -f "$logfile" ]]; then
        cp "$logfile" "$BACKUP_DIR/$(basename "$logfile")_$DATE.log"
        echo "[OK] Copiat: $logfile"
    elif [[ -d "$logfile" ]]; then
        tar -czf "$BACKUP_DIR/$(basename "$logfile")_$DATE.tar.gz" "$logfile"
        echo "[OK] Arhivat folder: $logfile"
    else
        echo "[ERORARE] Nu s-a gasit: $logfile"
    fi
done

echo "[DONE] Colectarea logurilor a fost finalizata."
