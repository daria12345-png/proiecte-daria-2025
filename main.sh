#!/bin/bash

# incarc scripturile externe
source "$(dirname "$0")/config.sh"
source "$(dirname "$0")/utils.sh"
source "$(dirname "$0")/filters.sh"
source "$(dirname "$0")/security_checker.sh"

echo "============================"
echo "   LOG MANAGER - RUNNING"
echo "============================"
echo "[*] Distributie detectata: $DISTRO"
echo

# 1. initializeaza directoarele
init_directories

# 2. Copiaza logurile definite in config
echo "[*] Copiere loguri standard..."
for log_file in "${LOG_FILES[@]}"; do
    copy_log "$log_file"
done

# 2.5. procesare loguri speciale (wtmp si journal)
echo "[*] Prelucrez loguri binare speciale..."

if [ -f /var/log/wtmp ]; then
    last -f /var/log/wtmp > "$CUSTOM_DIR/wtmp_parsed.txt"
    echo "    → wtmp_parsed.txt generat în custom/"
fi

if [ -d /var/log/journal ]; then
    journalctl --no-pager > "$CUSTOM_DIR/journal_dump.txt"
    echo "    → journal_dump.txt generat in custom/"
fi

# loguri apache2
if [ "$ENABLE_APACHE" = true ] && [ -f "$APACHE_LOG" ]; then
    echo "[*] Apache2 detectat – copiez $APACHE_LOG"
    cp "$APACHE_LOG" "$APACHE_DIR/"
fi

# loguri nginx
if [ "$ENABLE_NGINX" = true ] && [ -f "$NGINX_LOG" ]; then
    echo "[*] Nginx detectat – copiez $NGINX_LOG"
    cp "$NGINX_LOG" "$NGINX_DIR/"
fi

# 3. aplica filtrari (poti schimba datele si severitatea aici)
echo
echo "[*] Filtrare dupa data si severitate..."
filter_logs_by_date "2025-07-01" "2025-07-17"
filter_logs_by_severity "error"

echo
echo "[*] Extrag activitate CRON..."
filter_cron_activity

# 4. detecteaza incidente de securitate
echo
echo "[*] Verificare de securitate..."
check_security_issues

echo
echo "============================"
echo "    REZUMAT INCIDENTE"
echo "============================"

BF_FILE="$LOG_SAVE_DIR/ssh_bruteforce.txt"
SUSP_FILE="$LOG_SAVE_DIR/suspicious_installs.txt"

BF_COUNT=$(wc -l < "$BF_FILE" 2>/dev/null || echo 0)
SUSP_COUNT=$(wc -l < "$SUSP_FILE" 2>/dev/null || echo 0)

echo "   SSH brute-force:         $BF_COUNT incidente"
echo "   Instalari suspecte:      $SUSP_COUNT linii"

if [ "$BF_COUNT" -gt 0 ]; then
    echo "   ↪ Exemple brute-force:"
    head -n 3 "$BF_FILE"
    echo "   [...] (vezi logs/ssh_bruteforce.txt)"
fi

if [ "$SUSP_COUNT" -gt 0 ]; then
    echo "   ↪ Exemple instalari riscante / sudo:"
    head -n 3 "$SUSP_FILE"
    echo "   [...] (vezi logs/suspicious_installs.txt)"
fi 
