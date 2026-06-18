#!/bin/bash

#ścieżka do raportu
RAPORT="Raport.txt"

#za pomocą komendy journalctl sprawdzamy logi serwisu ssh(-u ssh) 24h wstecz(--since "24 hours ago"), zbieramy wszystkie logi z nieudaną próbą logownia, a nastepnie bierzemy tylko ip z błędu, sortujemy je zliczamy ilość powtarzających sie ip, nastenie sortujemy numericznie(-n) i odwrotnie(-r)
FAILED_IPS=$(sudo journalctl -u ssh --since "24 hours ago" | grep "Failed password" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort | uniq -c | sort -nr)

SUSPICIOUS_FOUND=false

#ilość prób nie udanego logowanie który wowoła alert
THRESHOLD=3

# Sprawdzamy, czy którykolwiek adres IP przekroczył ustalony próg
while read -r count ip; do
    if [[ "$count" -ge "$THRESHOLD" ]]; then
        SUSPICIOUS_FOUND=true
        break
    fi
done <<< "$FAILED_IPS"


#Sprawdzy czy doszło do naruszenie i generujemy raport
if [ "$SUSPICIOUS_FOUND" = true ]; then
    echo "RAPORT PODEJRZANEJ AKTYWNOŚCI SSH" > $RAPORT
    echo "Data wygenerowania: $(date)" >> $RAPORT
    echo "Próg alarmowy: $THRESHOLD nieudanych prób logownia" >> $RAPORT


    echo "Ilość prób | numer ipv4" >> $RAPORT

    #Generowanie raportu
    while read -r count ip; do

        if [[ "$count" -ge "$THRESHOLD" ]]; then
            echo "$count $ip" >> $RAPORT
        fi
    done <<< "$FAILED_IPS"
        
    echo "Wykryto podejrzaną aktywność! Raport zapisano w: $RAPORT"
    
else
    echo "Wszystko w porządku. Nie wykryto adresów IP z liczbą błędów powyżej $THRESHOLD."
fi