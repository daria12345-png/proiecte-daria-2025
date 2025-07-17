#!/bin/bash

# verifica loguri pentru posibile incidente de securitate
check_security_issues() {
    echo "[*] Verific incidente de securitate..."

    # 1. tentative brute-force SSH
    grep -i "Failed password" "$AUTHLOG_DIR"/* > "$LOG_SAVE_DIR/ssh_bruteforce.txt"
    echo "    → Tentative brute-force salvate in ssh_bruteforce.txt"

    # 2. instalari de pachete suspecte (ex: nmap, netcat, gcc)
    grep -Ei "install(ed)? (nmap|netcat|nc|gcc)" "$APTLOG_DIR"/* > "$LOG_SAVE_DIR/suspicious_installs.txt"
    echo "    → Instalari suspecte salvate in suspicious_installs.txt"

    # 3. esecuri autentificare sudo (ex: parola gresita)
    grep -Ei "sudo:.*authentication failure" "$AUTHLOG_DIR"/* >> "$LOG_SAVE_DIR/suspicious_installs.txt"
    echo "    → Esecuri sudo adaugate in suspicious_installs.txt"
}

