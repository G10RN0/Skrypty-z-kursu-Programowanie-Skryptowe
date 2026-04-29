#!/bin/bash
Host_name=$(hostname) #pobieramy nazwe urzadzenia
function aktualna_data(){ #tak tworzymy funkcje
    echo aktualna data na komputerze $Host_name wynosi: $(date) # pobieramy aktualna date komendą 'date'
}
function aktualna_wersja(){
    echo aktualna wersja na komputere $Host_name to: $(uname -a) #uname jest to komenda która pozwala wyswietlac inforamcje systemowe z arguemntem -a wyswyetla wszystko co moze zaoferowac
}
function uzytkownik(){
 echo Użytkownik na komputerze $Host_name , który aktualnie jest zalaogowany to $(whoami) # whoami ~ wyświetla aktualnie zalogowanego uzytkownika
}
function adres_ip(){
 echo adres loklany IP komputera $Host_name, to: $(hostname -I | cut -f 1 -d " ") #'hostname -I' wyświetla wszystkie adresy w komputerze. Pierwszym adresem jest nasz adres lokalny wiec go chcemy. Uzywamy komendy cut która usuwa tekst. argument -d ' ' mowi nam zeby podzielic teskt na slowo rodzielnonymi ' ', nastepnie -f 1 mowi ze chcemy tylko pierwszy element
}
aktualna_data #tak wywolujemy funkcje
aktualna_wersja
uzytkownik
adres_ip