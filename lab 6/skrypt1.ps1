[Int]$dlugosc = $args[0] #wczytujemy argument do zmiennej i upewniamy sie ze jest on INT
[Int]$wysokosc = $args[1]
$Pole = ($dlugosc*$wysokosc)/2 #Obliczmy pole i zapisujemy je w zmiennej
Write-Host "Pole trójkąta: $Pole" #wypisujemy wynik