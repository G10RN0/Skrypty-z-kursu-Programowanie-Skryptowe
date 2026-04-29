#!/bin/bash

#funckcja która z nazwy miasta uzyskuje kordynaty
function get_location(){
    #-s to jest skrócona nazwa --silient
    #uzyskujemy infomacje na temat miasto które nasz interesuje
    response=$(curl -s -X GET "https://api.openweathermap.org/geo/1.0/direct?q=$1&limit=1&appid=$2")

    #zapisujemy pierwszy kordynat
    lat=$(echo $response | jq -r ".[0].lat")

    #zapisujemy drugi kordynat
    lon=$(echo $response | jq -r ".[0].lon")

    echo "$lat $lon"
}

#głowna funkcja ktora generuje plik pdf z naszą infoamcją o pogodzie w danej lokacji
function get_weather(){
    #wywołujemy funkcje get_location, a nastpnie przekazujemy jej echo do funkcji read, która czyta to jak normalny user input
    read lat lon <<< $(get_location $1 $2)

    #dodaje infomacje o miescie do zmiennej
    pdf+=$(echo "Miasto: $1")$'\n'

    echo "Pobieranie informacji na temat pogody...."
    #uzyskujemy infomacje na temat aktualnej pogody na podanych korydantach
    response=$(curl -s -X GET "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$2")
    #dodaje infomacje o temepraturze w miescie do zmiennej
    pdf+="Obecna temperatura: $(echo $response | jq -r ".main.temp")C"$'\n'

    #dodaje infomacje o wilgostnosci powietrza w miescie do zmiennej
    pdf+="Obecna wilgotność powietrza:$(echo $response | jq -r ".main.humidity")%"$'\n'

    #uzyskujemy dane na temat pogody na podanych kordyantach dla pieciu nastepnych dni w interwałach co 3godz
    response=$(curl -s -X GET "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=$2")

    #dodajmy dany tekst do zmiennej
    pdf+=$'\n'"prognoza na 5dni :"$'\n'

    i=0
    echo "formatownie danych..."
    #pętal iteruje każdą wartość z listy która nie jest null'em
    while [[ $(echo $response | jq -r ".list.[$i]") != "null" ]]; do

        #dodaje infomacje o datacie danej prognozy do zmiennej
        pdf+=$'\n'"Porognaza dla : $(echo $response | jq -r ".list.[$i].dt_txt")"$'\n' #data
        
        #dodaje infomacje o temepraturze w miescie do zmiennej
        pdf+="temperatura: $(echo $response | jq -r ".list.[$i].main.temp")C"$'\n' #temp

        #dodaje infomacje o ciśnieniu w miescie do zmiennej
        pdf+="Ciśnienie: $(echo $response | jq -r ".list.[$i].main.pressure")"$'\n' #cisnienie

        #dodaje infomacje o wilgotności w miescie do zmiennej
        pdf+="Wilgotność powietrza: $(echo $response | jq -r ".list.[$i].main.humidity")%"$'\n' #wilgotnosc
 
        #dodaje infomacje o pogodzie w miescie do zmiennej
        pdf+="Pogoda: $(echo $response | jq -r ".list.[$i].weather.[0].main")"$'\n' #pogoda

        #dodaje szczegowlowe infomacje o pogodzie w miescie do zmiennej
        pdf+="Opis: $(echo $response | jq -r ".list.[$i].weather.[0].description")"$'\n' #opis

        #dodaje infomacje o zachmurzeniu w miescie do zmiennej
        pdf+="Zachmurzenie: $(echo $response | jq -r ".list.[$i].clouds.all")%"$'\n' #zachmurzenie

        #dodaje infomacje o wietrze w miescie do zmiennej
        pdf+="Wiatr: $(echo $response | jq -r ".list.[$i].wind.speed")km/h"$'\n' #predkosc wiatru

        #dodaje 1 do i
        ((i++))
    done
    echo "generowanie pliku z raportem ..."

    #przekazuje wszystko z zmiennej pdf do pliku raport.txt
    echo "$pdf" > raport.txt

    #przeształca raport.txt w plik pdf. Dokładniej generuje z nasze pliku txt obraz co tam pisze a nastepnie wkleja go do noewgo pliku pdf
    # -font ~ ustawia czcionke napisów w pdf | -pointsize ~ ustawia rozmiar czcionki | -density ~ ustawia jakość obrazu | text:raport.txt ~ nasz plik do konwersji
    convert -density 300 -font "Courier" -pointsize 12 text:raport.txt raport.pdf

    #usuwa plik raport.txt
    rm raport.txt
}

read -p "podaj api-key: " key #nie oddam mojego klucza
get_weather $1 $key # generuje prognoze
echo "raport gotowy"