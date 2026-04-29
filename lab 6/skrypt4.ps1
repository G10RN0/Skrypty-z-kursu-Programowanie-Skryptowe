$Baza = "192.168.0" #baza naszego ip

#nasza minimalna wartośc dla ostatniego oktektu
[Int]$Min = 0

#pętla która powtórzy sie 10razy, i wygeneruje nam 10 ip
for ([Int]$i=1;$i -le 11; $i++){
    
    #wybiermy losową liczbe z zakresu $min do $min+$i | dla pierwszego powtórzenia to bedzie $min=0 $min+$i=1
    $Random = Get-Random -Minimum $Min -Maximum ($Min + $i)
    
    #wypisujemy nasze nowe ip
    Write-Host "$Baza.$Random"

    #dodajmy nasze $i do $min
    $Min += $i
}