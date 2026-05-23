#Pobranie kodu waluty od uzytkownika
$Currency = (Read-Host "Podaj trzyliterowy kod waluty (np. USD, EUR, GBP)").ToUpper()

if ([string]::IsNullOrWhiteSpace($Currency) -or $Currency.Length -ne 3) {
    Write-Host "Niepoprawny kod waluty. Wymagane sa dokladnie 3 znaki."
    exit
}

#Wyznaczenie zakresu dat 5 dni wstecz do dzisiaj
$FromDate = (Get-Date).AddDays(-5).ToString("yyyy-MM-dd")
$ToDate = (Get-Date).ToString("yyyy-MM-dd")

#Pobranie danych przez curl.exe
$HistoryUrl = "https://fxapi.app/api/history/PLN/$Currency.json?from=$FromDate&to=$ToDate"
Write-Host "`n[i] Pobieranie danych z zakresu od $FromDate do $ToDate..."

try {
    #wyslanie zapytania http
    $RawJson = curl.exe -s $HistoryUrl
    if ([string]::IsNullOrWhiteSpace($RawJson)) {
        Write-Host "Nie otrzymano danych z API. Sprawdz poprawnosc adresu."
        exit
    }
    #konwersja json data na objekt powershell
    $Response = $RawJson | ConvertFrom-Json
} catch {
    Write-Host "[!] Wystapil blad podczas komunikacji z API za pomoca curl.exe."
    exit
}

#Przetwarzanie tablicy rates z JSON
if (-not $Response.rates) {
    Write-Host "Brak sekcji 'rates' w odpowiedzi API."
    exit
}

#wyciaganie naj wazniejszych infrmacji z odpowiedzi
$HistoryList = @()
foreach ($Item in $Response.rates) {
    $HistoryList += [PSCustomObject]@{
        Data = $Item.date
        Kurs = [double]$Item.rate
    }
}

# 5. Sortowanie i obliczanie roznic dzien do dnia
if ($HistoryList.Count -lt 2) {
    Write-Host "[!] Brak wystarczajacej ilosci danych do obliczenia roznic."
} else {
    # Sortowanie upewnia nas, ze idziemy chronologicznie
    $SortedHistory = $HistoryList | Sort-Object Data

    Write-Host "Data: $($SortedHistory[0].Data) | Kurs: $($SortedHistory[0].Kurs) | Roznica: --"
    
    for ($i = 1; $i -lt $SortedHistory.Count; $i++) {
        $Today = $SortedHistory[$i]
        $Yesterday = $SortedHistory[$i-1]
        
        $Difference = $Today.Kurs - $Yesterday.Kurs
        
        # Formatowanie wyswietlania roznicy (z precyzja do 6 miejsc)
        $DiffText = if ($Difference -gt 0) {
            "+$([math]::Round($Difference, 4))"
        } else {
            "$([math]::Round($Difference, 4))"
        }
        
        # Jesli to ostatni dzien z tablicy, oznaczamy go jako kurs najnowszy
        $Label = if ($i -eq $SortedHistory.Count - 1) { "Kurs najnowszy" } else { "Data" }
        Write-Host "$Label : $($Today.Data) | Kurs: $($Today.Kurs) | Roznica: $DiffText"
    }
}