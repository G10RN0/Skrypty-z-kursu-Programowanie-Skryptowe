#!/bin/bash
read -p "podaj liczbe: " LICZBA #pobiera liczbe do sprawdzenia
if [[ $LICZBA -ge 0 && $LICZBA%2 -eq 1 ]]; then # spradza czy liczba jest większa lub równa(-ge) 0 operatorem && sprawdzamy czy jeszcze liczba podzielona przez 2 da nam reszte równą(-eq) 1
    echo "Liczba $LICZBA jest dodatnia i nie pażysta"
else
    echo "liczba $LICZBA jest pażysta lub nie dodatnia"
fi