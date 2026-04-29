#!/bin/bash

# sprawdzamy hash naszego pliku i ją wypisuje
function sha256hash(){
    echo suma kontrolna sha256 pliku $1 to: $(sha256sum $1 | cut -d ' ' -f1)
}

#funkcja która skanuj plik i analizuje odpowidz od virus total
function scan(){
    #wypisanie hash'u
    sha256hash $1
    #wysyłamy nasz plik za pomocą curl POST i odbiermy infoamcje na temat naszego skanu
    #curl wysła zapytania do jakiejś domeny i dostaje od niej infoamcje
    # --sielient ~ nie pokazuje wyników | -X wysła zapytanie(request) | POST ~ wysyłamy coś do domeny | -H dodajemy jakąś wartość do header | -F (--form) ~ umożliwia wysłanie form data zazwyczaj w formie multipart/form-data.
    RESPONSE=$(curl --silent -X POST "https://www.virustotal.com/api/v3/files" -H "x-apikey: $2" -F "file=@$1")

    #z infoamcji na temat naszego skanu wyciagmy id naszego skanu
    #jq formatuje dane json i pomaga nam nimi zarzadac. W wielkim skrucie działo jako filter dla plikow json
    #-r ~ wypluwa nam surowe warto
    #jq -r '.data.id' -> data: {id: 'temp', cos: 'ktos'} -> temp | wypluwa nam wartosc z id ktore znajduje sie w data
    SCAN_URL=$(echo $RESPONSE | jq -r '.data.id')

    #wysyłamy zapytanie o informacji naszej analizy wysłanego pliku
    #GET ~ rządamy informacji od strony
    RESULT=$( curl --silent -X GET "https://www.virustotal.com/api/v3/analyses/$SCAN_URL" -H "x-apikey: $2")
    #spradzamy jak wygląda status naszej analizy wykonywanej przez virustotal. i jeśli nie ma statusu 'completed' to wykonuje sie akcja w petli ktora czeka 30sec, a nastepnie wysyla zapytanie znowu o statusie naszej analizy
    while [[ $(echo $RESULT | jq -r '.data.attributes.status') != 'completed' ]]; do
        echo pending...
        sleep 30
        #wysyłamy zapytanie o informacji naszej analizy wysłanego pliku
        RESULT=$( curl --silent -X GET "https://www.virustotal.com/api/v3/analyses/$SCAN_URL" -H "x-apikey: $2")
    done

    #sprawdzamy czy w naszej ukonczonej analizie wystepuje wartość większa od 0 o kluczu malicious, jesli tak to plik jest niebezpieczny o kluczu suspicious, jesli tak to plik jest podejrzany
    if [[ $(echo $RESULT | jq -r '.data.attributes.stats.malicious') -gt 0 ]]; then
        echo "plik $1 jest niebezpieczny"

        #sprawdzamy czy w naszej ukonczonej analizie wystepuje wartość większa od 0 o kluczu suspicious, jesli tak to plik jest podejrzany
    elif [[ $(echo $RESULT | jq -r '.data.attributes.stats.suspicious') -gt 0 ]]; then
        echo "plik $1 jest podejrzany"

         #jesli zaden warunek nie wystapi to sie wykona ten
    else
        echo "plik $1 jest bezpieczny"
    fi
}
#sprawdaamy czy virus total wykona poprawny skan dla pliku eicar
function test(){
    #pobiermay wartość z strony eicar i wpisujemy ja do pliku
    curl --silent -X GET https://secure.eicar.org/eicar.com > testfile.com.txt
    scan testfile.com.txt $1 # wykonujemy skan dla tego lpiku
    rm testfile.com.txt # usuwamy ten plik
}

function main(){
    read -p "Co chcesz wykonać(1 lub 2):"$'\n'"1.Skan pliku"$'\n'"2.Test EICAT"$'\n' decison #wczytuje nasza decyzje

    #wykonuje coś dla innej decyzji
    if [[ $decison == "1" ]]; then
        read -p "api key: " key #wczytuje klucz do api virus total(nie oddam swojego)
        read -p "ścieżka do pliku: " path #wczytujemy ścieżke do pliku
        scan $path $key #skanuje nasz plik
    elif [[ $decison == "2" ]]; then
        read -p "api key: " key #wczytuje klucz do api virus total(nie oddamswojego)
        test $key #testuje skaner
    else
        echo "wpisz 1 jesli chcesz pocje piwerwsza lub 2 drugą"
    fi
}

main