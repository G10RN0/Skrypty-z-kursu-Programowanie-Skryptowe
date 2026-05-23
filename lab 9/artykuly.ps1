# Pobieranie danych od użytkownika
$Temat = Read-Host -Prompt "Wpisz szukany temat (np. technologia)"
$ApiKey = Read-Host -Prompt "Podaj swoj klucz API z newsapi.org"

# Bezpieczne zakodowanie tematu do adresu URL np. spacje na %20
$QueryEncoded = [Uri]::EscapeDataString($Temat)

# Konstruowanie adresu URL (szukamy artykułów w języku polskim)
$Url = "https://newsapi.org/v2/everything?q=$QueryEncoded&language=pl&sortBy=publishedAt&apiKey=$ApiKey"

Write-Host "Wyszukiwanie artykulow dla frazy: '$Temat'..."

try {
    # Wysłanie zapytania HTTP 
    $Odpowiedz = curl.exe -s $Url | ConvertFrom-Json

    if ($Odpowiedz.status -eq "ok") {
        $Artykuly = $Odpowiedz.articles

        if ($Artykuly.Count -eq 0) {
            Write-Host "Nie znaleziono zadnych artykulow dla podanego tematu."
            return
        }

        Write-Host "Znaleziono $($Odpowiedz.totalResults) artykulow. Wyswietlam najnowsze:`n"

        # Iteracja po wynikach i wyświetlenie szczegółów
        foreach ($artykul in $Artykuly) {
            Write-Host "Tytul: $($artykul.title)"
            
            Write-Host "Zrodlo: $($artykul.source.name)"
            
            Write-Host "Data publ.: $($artykul.publishedAt)"
            
            Write-Host "Link: $($artykul.url)"
            
            Write-Host ("-" * 60)
        }
    } else {
        Write-Error "API zwrocilo blad: $($Odpowiedz.message)"
    }
}
catch {
    Write-Error "Wystapil problem podczas polaczenia z API: $_"
}