#! /bin/bash
read -p "Wprowadź nazwe użystkownika: " username #pobiera nazwe użytkownika
if [[ "$username" == "root" ]]; then #sprawdza czy poadna nazwa użytkownika jest rowna root(admin)
    echo "Konto admina"
else
    echo "To nie jest konto admina"
fi