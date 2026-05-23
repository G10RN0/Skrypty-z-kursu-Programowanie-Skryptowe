#!/bin/bash
#sprawdzamy czy do skryptu podanao jeden argumnet (ścieżka do pliku)
if [[ $# -ne 1 ]];
then
    echo "przyjumje tylko jeden argument"
    exit -1
else
    if [[ -f $1 ]]; #spradzamy czy plik istnieje
    then
        #-all= ~ ustawia wszystko na None, inaczej usuwa naszą metdata
        exiftool -all= $1
        echo "metadata usunięta"
    else
        echo "nie prawidłowa ścieżka do pliku"
        exit -1
    fi
fi