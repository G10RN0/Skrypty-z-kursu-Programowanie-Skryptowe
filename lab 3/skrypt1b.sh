#!/bin/bash
read -p "Podaj szerokość Prostokąta:" X #linijka wczytuje dane z terminala i przechowuje je w zmiennej X
read -p "Podaj długość prostokąta: " Y #linijka wczytuje dane z terminala i przechowuje je w zmiennej Y
echo Pole prostokąta wynosi $(($X*$Y))