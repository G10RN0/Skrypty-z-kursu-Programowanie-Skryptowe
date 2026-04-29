#!/bin/bash
ADRES="192.168.1.x" #Specjalny adres przyszykowany na podmiane ostatniej czesci
MAX=1
for i in {1..10}; do # Generujemy 10 adresów, wiec dla każdego jednego jest jedna iteracje w pętli for
 MAX=$(((RANDOM % 10)+$MAX+$i)) # Generujemy losową liczbę od i dzielimy ją z resztą przez 10 by uzyskac liczby z przedziału 1-9, następnie dodajemy poprzednią losową liczbe wygenerowaną i numer adresu aby upewnić się że liczby się nie powtarzają a każda kolejna jest większa od poprzedniej
 echo $(echo $ADRES |sed "s/x/$MAX/g") #Bierzemy nasz przygotowany adres i zamienimay w nim X na naszą wygenerowaną liczbe
done
