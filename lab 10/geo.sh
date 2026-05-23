#!/bin/bash
#sprawdzamy czy do skryptu podanao jeden argumnet (ścieżka do pliku)
if [[ $# -ne 1 ]];
then
    echo "przyjumje tylko jeden argument"
    exit -1
else
    if [[ -f $1 ]]; #spradzamy czy plik istnieje
    then
        #exiftool to komenda która pozwala nam wyświetlić metadane z zdjęć | -j ~ przekształca output na json
        metadata=$(exiftool -j $1) #zapisujemy wynik z exiftool
        echo "GPS Location: $(echo $metadata | jq -r ".[0].GPSPosition")" # wyciągmy pozyjce gps za pomocą jq
        echo "GPS Altitude $(echo $metadata | jq -r ".[0].GPSAltitude")" # wyciągmy wysokość gps za pomocą jq
    else
        echo "nie prawidłowa ścieżka do pliku"
        exit -1
    fi
fi