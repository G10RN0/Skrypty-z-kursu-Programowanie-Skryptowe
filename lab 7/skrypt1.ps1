$doclowa_path = Read-Host -Prompt "Podaj sciezke do folderu docelowego: "
$monitor_path = Read-Host -Prompt "Podaj sciezke do folderu ktory chcemy monitorowac: "

#Test-Path ~ sprawdsza czy ścieżka istnieje
if (!(Test-Path $doclowa_path)) {
    #New-Item tworzy nowy item, -ItemType Directory ~ jest katalogiem ~ -Path $doclowa_path o danej ścierzce co towrzy nam nowy katalog
    New-Item -ItemType Directory -Path $doclowa_path | Out-Null
    #out-null ~ usuwa nam odpowiedz new-item zeby nic sie nie wyswietlalo na konsoli
}
if (!(Test-Path $monitor_path)) {
    New-Item -ItemType Directory -Path $monitor_path | Out-Null
}

Write-Host "Mozna wyjsc z programu za pomoca ctrl+C"
#nieskończona petla
while ($true) {
    #Get-ChildItem ~wlistuje czy isnieją pliki/katalogi w danej ścieżce | -Path $monitor_path ~ ściezka która sprawdzamy | -File ~ muszą to być pliki
    foreach ($file in Get-ChildItem -Path $monitor_path -File){
        # dostajemy plik jako $file
        #sprawdzamy czy coś sie nie powiodło
        try {
            #Join-Path ~łączy dwie śćiezki ze sobą | $file.Name ~ bierzemy tylko nazwe pliku
            $destination = Join-Path $doclowa_path $file.Name
            #$file.fullname ~ ścieżka absolutna do pliku | Move-Item ~ przenosi plik o ścieżce podaną w -Path do wartości podanej w -Destiantion
            Move-Item -Path $file.FullName -Destination $destination -ErrorAction Stop
            #-ErrorAction Stop ~ zatrzymuje i wyrzuca error przy jakiś błędach podaczas przenosienia plików
        } catch {
            Write-Host "coś poszło nie tak podczas przenoszenia pliku"
        }
    }
    #usypiamy program na pół sekundy bo nie musi ciągle sprawdzać
    Start-Sleep 0.5
}