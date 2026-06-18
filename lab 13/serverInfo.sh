#!/bin/bash

# Zapisywanie listy plików ze zdalnego serwera do lokalnego pliku
sshpass -p 'lab' ssh lab@127.0.0.1 "whoami" > uzytkownik.txt

# Zapisywanie listy procesów ze zdalnego serwera do lokalnego pliku
sshpass -p 'lab' ssh lab@127.0.0.1 "ps aux" > Procesy.txt

# Zapisywanie listy plików ze zdalnego serwera do lokalnego pliku
sshpass -p 'lab' ssh lab@127.0.0.1 "ls -all" > pliki.txt

echo "Pobrano dane ze zdalnego serwera i zapisano do plików."

