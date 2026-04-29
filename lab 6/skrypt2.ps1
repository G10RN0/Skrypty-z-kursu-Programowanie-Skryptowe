[Int]$Liczba = Read-Host -Prompt "Podaj liczbe: " #wczytujemy teskt z konsoli i upeniamy sie ze jest to licba,a nastepnie zapisujemy ja w zmiennej

#sprawdzamy czy liczba jest wieksza od 10
if ($Liczba -gt 10) {
    Write-Host "Liczba jest wieksza od 10" #jesli jest to wypisujemy do konsoli dany tekst
} else {
    Write-Host "Liczba jest mniejsza od 10"# jesli nie jest to wypisujemy dany teskt
}