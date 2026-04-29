#!/bin/bash
read -p "Podaj nazwe użytkownika: " LOGIN
read -p " Podaj hasło do użytkownika: " PASSWORD
LOGINS="admin"
PASSWORDS="password"
if [[ $LOGIN == $LOGINS && $PASSWORD == $PASSWORDS ]]; then # sprawdza czy hasło z kodu jest równe z tym ktore użytkownik podał i jescze tak samo sprawdza login
    echo "Poprawne hasło dla loginu: $LOGIN"
else
    echo "błędne hasło lub login"
fi