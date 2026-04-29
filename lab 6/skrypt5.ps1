#funkcja która zwraca aktualną date z komputera
function Aktualna_Data {
    return Get-Date
}

#funkcja która zwraca aktulną wersje systemu
function Wersja_Systemu {
    return [Environment]::OSversion
}

#funckja która zwraca nazwe aktualnego użytkownika
function Uzytkownik {
    return $env:USERNAME
}

#funkcja która zwraca ip komputera
function Adres_IP {
    #pobiermy table z adresami dla ipv4 nastepnie wybiermy tylko InterfaceAlias IPAddress, a nastpnie zamienmy wszytko na string Out-String'em
    return Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress | Out-String
}

#pobiermy nazwe komputera z zmiennych środowiskowych
$ComputerName = $env:COMPUTERNAME

#wypisujemy wszytkie funckje
Write-Host "Aktualna data na komputerze $ComputerName to: $(Aktualna_Data)"
Write-Host "Aktualna wersja systemu na komputerze $ComputerName to: `n $(Wersja_Systemu)"
Write-Host "Uzytkownik ktory jest aktualnie aktywny na komputerze $ComputerName to: $(Uzytkownik)"
Write-Host "Dane ipv4 dla komputera $ComputerName : `n $(Adres_IP)"
