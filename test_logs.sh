#!/bin/bash

echo "[*] Pun linii de test in logurile locale:"

# linia de ERROR in syslog
echo "Jul 15 14:23:00 localhost kernel: ERROR simulated kernel panic" >> logs/syslog/syslog

# linie WARNING in auth.log
echo "Jul 12 18:45:00 localhost sshd[1234]: WARNING failed login attempt from 192.168.1.50" >> logs/auth/auth.log

# linie INFO in apt/history.log
echo "Jul 10 10:00:00 apt install cowsay  # INFO Just for fun" >> logs/apt/history.log

# linie suspecta pentru sudo fail
echo "Jul 14 16:11:22 localhost sudo:    user : authentication failure ; TTY=pts/1 ; PWD=/home/user ; USER=root" >> logs/auth/auth.log

# linie cu instalare pachet suspect
echo "Install: nmap:amd64 (7.91+dfsg1-1ubuntu1)" >> logs/apt/history.log

# linie pentru bruteforce SSH
echo "Jul 13 19:01:00 localhost sshd[2345]: Failed password for invalid user root from 10.10.10.10 port 4242 ssh2" >> logs/auth/auth.log

echo "[✓] Liniile de test au fost adaugate!"
