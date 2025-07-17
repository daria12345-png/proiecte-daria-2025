# 📄 Log Manager Bash Application

## 📌 Descriere generala

Aceasta aplicatie Bash gestioneaza si monitorizeaza logurile de sistem din distributii Linux (Ubuntu, Linux Mint, Fedora), oferind functionalitati avansate precum:
- colectarea si organizarea logurilor in directoare dedicate,
- filtrarea logurilor dupa data sau severitate (ex: `ERROR`, `WARNING`),
- detectarea incidentelor de securitate (ex: tentative brute-force SSH, instalari pachete periculoase),
- suport pentru loguri de servicii instalate (ex: apache2, nginx),
- detectie automata a distributiei pentru compatibilitate totala.

---

## 🛠 Structura directoare

```bash
log_manager/
├── logs/                     # Toate logurile colectate
│   ├── syslog/               # Loguri de sistem
│   ├── auth/                 # Loguri de autentificare
│   ├── apt/                  # Loguri despre instalări (sau dnf)
│   ├── custom/               # loguri speciale (wtmp/journal)
│   ├── apache2/              # loguri apache (dacă exista)
│   ├── nginx/                # loguri nginx (dacă exista)
│   ├── cron/                 # activitate cron extrasa
│   ├── filtered/             # filtrari după severitate
│   ├── ssh_bruteforce.txt    # tentative autentificare esuata
│   └── suspicious_installs.txt # instalari riscante sau sudo fail
├── main.sh                  # Script principal
├── config.sh                # Configurare directoare + distributie
├── utils.sh                 # Copiere loguri + directoare
├── filters.sh               # Filtrare loguri
├── security_checker.sh      # Detectare incidente de securitate
├── test_logs.sh             # Inserare loguri de test
└── clean_test_logs.sh       # Stergere loguri de test
```

---

## ▶️ Cum rulez aplicatia?

1. Te asiguri ca ai permisiuni pentru a accesa logurile (ruleaza ca user cu permisiuni sau cu `sudo`)
2. Rulezi direct:
```bash
./main.sh
```

---

## 📤 Ce face `main.sh`?

1. Detecteaza distributia (Ubuntu/Mint sau Fedora)
2. Creeaza toate directoarele necesare in `logs/`
3. Copiaza logurile sistemului si ale serviciilor apache/nginx (daca sunt instalate)
4. Proceseaza loguri speciale: `wtmp`, `journal`
5. Aplica filtre:
   - dupa data (modificabil in script)
   - dupa severitate (ex: `error`)
6. Extrage activitatea CRON din loguri
7. Verifica incidente de securitate:
   - brute-force SSH
   - autentificari `sudo` esuate
   - instalari de pachete riscante
8. Afiseaza un **rezumat in terminal** + salveaza fisierele

---

## 🔍 Cum testez aplicatia?

Folosind scriptul de test:

```bash
./test_logs.sh
```

✅ Acesta insereaza automat:
- erori in `syslog`
- brute-force SSH in `auth.log`
- comenzi cron
- instalari periculoase (ex: `nmap`)

Apoi rulezi din nou:

```bash
./main.sh
```

✅ Vei vedea rezultatele in fisierele din `logs/` si in terminal.

---

## 🧹 Cum curat logurile de test?

Rulezi:

```bash
./clean_test_logs.sh
```

Acesta sterge automat toate liniile adaugate de `test_logs.sh`.

---

## ✅ Ce este implementat:

| Functionalitate                        | Status     |
|----------------------------------------|------------|
| Colectare loguri sistem (syslog, auth, etc.) | ✅ complet |
| Suport Fedora (mesaje, secure, cron)  | ✅ complet |
| Salvare loguri in directoare clare     | ✅ complet |
| Filtrare dupa data                     | ✅ complet |
| Filtrare dupa severitate               | ✅ complet |
| Detectare incidente brute-force SSH    | ✅ complet |
| Detectare instalari pachete riscante   | ✅ complet |
| Suport apache2 / nginx                 | ✅ complet |
| Loguri CRON extrase separat            | ✅ complet |
| Jurnal si wtmp procesate               | ✅ complet |
| Inserare + curatare loguri de test     | ✅ complet |
| Afisare clara in terminal              | ✅ complet |

---

## 📌 Cerinta 100% Respectata

Aplicatia respecta integral cerinta proiectului si include chiar si functionalitati extra pentru testare si curatare, fiind complet portabila intre distributii.

---

## 👤 Autor

> Nume: Dina Daria-Elena  
> Proiect realizat pentru cursul: Practica de Domeniu
