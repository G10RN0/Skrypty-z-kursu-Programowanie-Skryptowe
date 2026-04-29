#funkcja która zabiera ścieżke do pliku i zwraca hash pliku
function get_hash {
    #pozwala na wprowadzanie do funkcji wartości z poza funckji
    param (
        [String]$file_path
    )
    #Get-FileHash ~ zwraca hash z pliku o ścieżce podanej w -Path | -Algorithm tutaj wybiermy algorytm jaki chcemy użyć
    return (Get-FileHash -Path $file_path -Algorithm MD5).Hash
}

#funckja która zabiera ścieżke do pliku i api_key do virus_total, by wrócić raport na temat pliku
function get_raport {
    param (
        [String]$file_path,
        [String]$api_key
    )

    #wysyłamy nasz plik za pomocą curl POST i odbiermy infoamcje na temat naszego skanu
    #curl wysła zapytania do jakiejś domeny i dostaje od niej infoamcje
    # --silent ~ nie pokazuje wyników | -X wysła zapytanie(request) | POST ~ wysyłamy coś do domeny | -H dodajemy jakąś wartość do header | -F (--form) ~ umożliwia wysłanie form data zazwyczaj w formie multipart/form-data | W from data wysłamy nasz plik
    $response = curl.exe --silent -X POST "https://www.virustotal.com/api/v3/files" -H "x-apikey: $api_key" -F "file=@$file_path" | ConvertFrom-Json 
    #ConvertFrom-Json ~ przeszktałca json na obiekt w powershell'u

    #response.data.id ~ wyciągamy id z naszych infoamcji które dostaliśmy, po wyłaniu pliku
    #wysyłamy zapytanie o informacji naszej analizy wysłanego pliku
    #GET ~ rządamy informacji od st
    $result= curl.exe --silent -X GET "https://www.virustotal.com/api/v3/analyses/$($response.data.id)" -H "x-apikey: $api_key" | ConvertFrom-Json

    #Wysyłamy zapyatanie o nasz skan aż do poki nie bedzie gotowy
    #sprawdzamy czy jest "completed" jak nie powtarzamy wszystko w petli
    while ($result.data.attributes.status -ne "completed") {
        Write-Host "pending..."
        Start-Sleep 30 #darmowa wersja zapewnia 4 zapytania na minute

        #Wysyłamy zapyatanie o nasz skan
        $result= curl.exe --silent -X GET "https://www.virustotal.com/api/v3/analyses/$($response.data.id)" -H "x-apikey: $api_key" | ConvertFrom-Json
    } 
    
    #sprawdzamy rezultaty
    if ($result.data.attributes.stats.malicious -gt 0) {
        Write-Output "plik jest niebezpieczny"
    } elseif ($result.data.attributes.stats.suspicious -gt 0) {
        Write-Output "plik jest podejrzany"
    } else {
        Write-Output "plik jest bezpieczny"
    }
}

#funckja ktora pobiera api_key i zwraca czy raport przeszedł test w którym sprawdza plik EICAR
function test_raport {
    param (
        [String]$api_key
    )
    #pobiermay plik EICAR do pliku
    curl.exe --silent -X GET "https://secure.eicar.org/eicar.com" | Out-File "testfile.txt"
    
    #zapisujemy wynik raportu w zmiennej output
    $output = get_raport "testfile.txt" $api_key

    #usuwamy plik EICAR
    Remove-Item -Path "testfile.txt" | Out-Null

    #match ~ sprawdza czy w tekscie wysępuje specyficzny ciąg znaków
    if($output -match "plik jest niebezpieczny"){
        Write-Host "Test zakonczony pomyslnie"
    }else{
        Write-Host "Test zakonczony porazka"
    }
}

#input
$file = Read-Host -Prompt "podaj sciezke do pliku: "
$api_key = Read-Host -Prompt "podaj swoj api key: "

#wypisujemy hash
Write-Host "Suma kontrolna pliku: $(get_hash $file)"
#generujemy raport
Write-Host "$(get_raport $file $api_key)"

#[TRZEBA ODKOMNETOWAĆ] żeby wykonać test
#test_raport $api_key