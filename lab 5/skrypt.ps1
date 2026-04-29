#tworzymy plik o nazwie moj_plik.txt
New-Item -Path "moj_plik.txt" -ItemType File

#zmieniamy nazwe pliku moj_plik.txt na nowa_nazwa.txt
Rename-Item -Path "moj_plik.txt" -NewName "nowa_nazwa.txt"

#hashujemy plik za pomocą sha256
Get-FileHash -Path "nowa_nazwa.txt"

#uruchamiamy notatnik
Start-Process notepad

#Wypisujemy wszystkie pliki z work dir, a potem je sortujemy za pomcą długości nazwy
Get-ChildItem | Sort-Object -Property { $_.Name.Length }

#przypisujemy do zmiennej ścieżke w której aktualnie się znajdujemy
$Lokalizacja = Get-Location

#Tworzymy nowy plik ścieżka.txt wkładamy zawartośc zmiennej $lokalizacja
$Lokalizacja | Out-File -FilePath "ścieżka.txt"

#wypisujemy wszystkie procesy ktore działaja na komputerze a nastepnie wypisujemy tylko pierwsze 5 i tylko kolumny z nazwą i id
Get-Process | Select-Object -First 5 -Property Name, Id

#wypisujemy wszystkie procesy ktore działaja na komputerze a nastepnie sortujemy je malejaco wobec kolumny o nazwie WS, pozniej wypisuejmy tylko 5 pierwszych wyników
Get-Process | Sort-Object -Property WS -Descending | Select-Object -First 5
