#!/bin/bash
read -p "Wprowadź nazwe pliku: " FILENAME #pobieramy ścieżke pliku
if [[ -f "$FILENAME" ]]; then # -f sprawdza czy plik isnieje posiadający daną ścieżke
    echo "PLik istnieje"
    
    if [[ ! -s "$FILENAME" ]]; then #-s sprawdza czy plik istnieje i czy nie jest pusty | Natomiast ! to jest zaprzeczenie, wiec teraz sprawdza czy plik istnieje i czy plik jest w jakis sposób zapisany
        echo "Plik jest pusty"
    else
        echo "Plik nie jest pusty"
    fi

    if [[ -d "$FILENAME" ]]; then # -d sprawdza czy plik jest katalogiem
        echo "Plik jest katalogiem"
    else
        echo "Plik nie jest katalogiem"
    fi
else
    echo "Plik nie istnieje"
fi