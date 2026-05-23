# Pobieranie danych od uzytkownika
$IPAddress = Read-Host "Podaj adres IP do sprawdzenia"
$ApiKey = Read-Host "Podaj swoj klucz API Shodan"

# Konstruowanie adresu URL dla Shodan API
$url = "https://api.shodan.io/shodan/host/$($IPAddress)?key=$ApiKey"
Write-Host $url
Write-Host "Pobieranie danych..."

# Wywolanie curl.exe i zapisanie wyniku do zmiennej
$jsonResponse = curl.exe -s $url

# Sprawdzenie czy curl zwrocil jakas odpowiedz
if ($jsonResponse -eq $null -or $jsonResponse -eq "") {
    Write-Host "Blad: Nie udalo sie pobrac danych."
    exit
}

# Konwersja surowego JSON z curl na obiekt PowerShell
$response = $jsonResponse | ConvertFrom-Json

# Sprawdzenie czy API Shodan zwrocilo blad
if ($response.error) {
    Write-Host "Blad z API Shodan: $($response.error)"
} else {
    Write-Host "WYNIKI SHODAN DLA: $IPAddress"
    Write-Host "Podstawowe dane:"
    Write-Host "* Organizacja: $($response.org)"
    Write-Host "* ISP: $($response.isp)"
    Write-Host "* Kraj: $($response.country_name) ($($response.country_code))"
    Write-Host "* Miasto: $($response.city)"
    
    $osName = "Nieznany"
    if ($response.os) { $osName = $response.os }
    Write-Host "* System operacyjny: $osName"
    
    Write-Host ""
    Write-Host "Otwarte porty:"
    if ($response.ports) {
        # Sortowanie portow rosnaco
        $sortedPorts = $response.ports | Sort-Object
        $portsString = $sortedPorts -join ", "
        Write-Host "* $portsString"
    } else {
        Write-Host "* Brak otwartych portow w bazie Shodan dla tego IP."
    }
    
    Write-Host ""
    Write-Host "Ostatnia aktualizacja bazy: $($response.last_update)"
}