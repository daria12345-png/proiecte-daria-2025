#!/bin/bash

echo "[*] Sterg liniile de test adaugate manual in loguri:"

# curatare rapida cu sed (elimina liniile care conțin 'simulated', 'Just for fun', 'Failed password' etc.)
sed -i '/simulated kernel panic/d' logs/syslog/syslog
sed -i '/failed login attempt/d' logs/auth/auth.log
sed -i '/Just for fun/d' logs/apt/history.log
sed -i '/authentication failure/d' logs/auth/auth.log
sed -i '/nmap:amd64/d' logs/apt/history.log
sed -i '/Failed password for invalid user/d' logs/auth/auth.log

echo "[✓] Logurile de test au fost curatate."
