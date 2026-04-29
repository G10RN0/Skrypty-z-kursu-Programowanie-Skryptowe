$Uzytkownik = Read-Host -Prompt "Podaj nazwe uzytkownika: " #wczytujemy teskt z konsoli

$ZaszyfrowaneHaslo = Read-Host -AsSecureString -Prompt "Podaj haslo: " #wczytujemy teskt z konsoli, a natsepnie przechowujemy go jako SecureText

#zeby odzysakc nasze zaszyfrowane haslo trzeba utowrzyc nowy obiekt PSCredential i podac co kolwiek do pola login i nasze zaszyforwane hasło do pola z hasłem
#nastepnie używamy .GetNetworkCredential().Password by dostać nasze hało jako czysty teskt
$Haslo = (New-Object System.Management.Automation.PSCredential($Uzytkownik, $ZaszyfrowaneHaslo)).GetNetworkCredential().Password

#sprawdzamy czy hasło jest zgodne jak i również nazwa użytkownika
if ($Uzytkownik -eq "admin" -and $Haslo -eq "password") {
    Write-Host "Poprawne logowanie" # wypisujemy to jesli jest poprawnie
} else {
    Write-Host "Bledne hasło lub login" # wypisujemy to jesli nie jest poprawnie
}