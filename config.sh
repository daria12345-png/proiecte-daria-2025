#!/bin/bash

# detecteaza distributia (Ubuntu, Mint, Fedora etc.)
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID  # exemple: ubuntu, mint, fedora
else
    DISTRO="unknown"
fi

# directorul bazei proiectului
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_SAVE_DIR="$BASE_DIR/logs"
SYSLOG_DIR="$LOG_SAVE_DIR/syslog"
AUTHLOG_DIR="$LOG_SAVE_DIR/auth"
APTLOG_DIR="$LOG_SAVE_DIR/apt"
CUSTOM_DIR="$LOG_SAVE_DIR/custom"

# directoare salvare servicii
APACHE_DIR="$LOG_SAVE_DIR/apache2"
NGINX_DIR="$LOG_SAVE_DIR/nginx"

# detectare automata servicii instalate
ENABLE_APACHE=false
ENABLE_NGINX=false

if command -v apache2 >/dev/null 2>&1 || [ -d /etc/apache2 ]; then
    ENABLE_APACHE=true
fi

if command -v nginx >/dev/null 2>&1 || [ -d /etc/nginx ]; then
    ENABLE_NGINX=true
fi

# cale loguri servicii
APACHE_LOG="/var/log/apache2/access.log"
NGINX_LOG="/var/log/nginx/access.log"

# ========================
# LOGURI SISTEM - IN FUNCTIE DE DISTRO
# ========================

if [[ "$DISTRO" == "fedora" ]]; then
    # loguri specifice Fedora
    LOG_FILES=(
        "/var/log/messages"
        "/var/log/secure"
        "/var/log/dnf.log"
        "/var/log/wtmp"
        "/var/log/journal"
	"/var/log/cron"
    )
else
    # loguri implicite pentru Ubuntu/Mint
    LOG_FILES=(
        "/var/log/syslog"
        "/var/log/auth.log"
        "/var/log/apt/history.log"
        "/var/log/wtmp"
        "/var/log/journal"
    )
fi

# ========================
# afisam distributia si logurile urmarite
# ========================
echo "============================"
echo "  Sistem detectat: $DISTRO"
echo "  Loguri monitorizate:"
for log in "${LOG_FILES[@]}"; do
    echo "   → $log"
done
echo "============================"
