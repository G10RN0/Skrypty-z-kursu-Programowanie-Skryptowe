#!/bin/bash
#zeby wykonac ten program wieszosc komend wymaga uprawnien admina
#dodaje nowego uzytkownika
function add_user(){
    sudo useradd -m -d "/home/$1" $1 #-d ~ ustawia katolog domy | -m ~tworzy katolog domowy jesli go nie ma
    echo "profil $1 został stworzony"
}
# tworzymy trzy nastepujace foldery w folderze domowym nowego uzytkownika
function setup_user(){
    sudo mkdir "/home/$1/Videos"
    sudo mkdir "/home/$1/Pictures"
    sudo mkdir "/home/$1/Dcouments"
}
#wypsiuje infomacje na temat naszego systemu i oprogramowania
function info(){
    echo Nasze ip to: $(hostname -I | cut -f 1 -d " ") # zabieramy pierwszy element odzielacy spacja reszte by zdobic ip
    echo Nasz MAC to: $(ifconfig | grep "ether " | awk '{print $2}') #bierzemy linie gdzie jest "ether " a nastepnie bierzemy 2 element po spacjach
    echo nasza werscja oprogramowania to: $(uname -a) # bierzmy ogolne informacje o oprgramowaniu
}

#funkcja ktora aktualizuje nam system i wyświetla liste dostępnych aktualizacji
function update_upgreade(){
    sudo apt update #sprawdza dostpne aktualizacje
    echo apt update zakończona kodem $? # $? ~ pokazuje nam kodw wyjsciowy ostatniej komendy
    sudo apt list --upgradeable # wyswietla nam liste oprogramowan ktore mozemy zaktualizowac
    #wybieramy czy chcemy zaktulizowac system czy nie
    read -p "chcesz zaktulizować system?(y/n): " DECISION
    #sprawdza czy wpisalismy 'y'
    if [[ $DECISON == "y" ]]; then
        sudo apt upgrade # aktualizuje system
        echo apt upgrade zakończona kodem $?
        #sprawdza czy wpisalismy 'n'
    elif [[ $DECISON == "n" ]]; then
        echo "nie aktualizuje"
        #wszystko inne
    else
        echo "wybrałeś inna opcje ktora tez oznacza nie"
    fi
}

#pobieramy klienta mail'owego thunderbird
function mail(){
    sudo apt install thunderbird # instalujemy thunderbird
    echo instalcja zakończona kodem: $?
}
#nasza głowna funkcja
function main(){
    read -p "Podaj nazwe nowego użytkownika:" USER #wczytujemy nazwe nowego uzytkownika
    add_user $USER #dodajmey nowego uzytkownika i przekazuje nazwe uzytkownika
    setup_user $USER #tworzymy trzy foldery() w katalogu domowym i przekazujemy do funkcji nazwe uzytkownika
    info # wypisujemy adres mac, ip i informacje o oprogramowaniu
    update_upgreade #aktualizujemy system
    mail #instalujemy thunderbird
}
main # wywołujemy nasza funkcje
