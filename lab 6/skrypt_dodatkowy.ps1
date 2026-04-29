#niebede tutaj komentował starych rzeczy bo skrypt jest prawnie taki sam jak z skrypt6.ps1

$file = Import-Csv -Delimiter ";" .\input_file.csv
$info = Get-ComputerInfo

#Nazwa pliku w którym zosatanie zapisany raport
#zeby sformatować Get-Date używamy toString z takim kodowaniem y-lata M-miesiąc d-dzień H-godziny m-minuty s-sekundy
$raport_name = "ComputerRaport_$((Get-Date).ToString("yyyyMMdd-HHmmss")).txt"

#w taki sposób zapisaujmy co kolwiek do pliku, tak samo jak do konsoli tylko jescze trzeba pipe'nąć to do Out-File
#zapisujemy "RAPORT" do pliku bez nadpisania pliku bo chcemy aby RAPORT był zapisywany od początku pliku
Write-Output "RAPORT" | Out-File $raport_name

foreach ($item in $file){
    if ($item.Component -eq "Computername" -and $item.GenerateReport -eq $true){
        #zapsiujemy $env:COMPUTERNAME do pliku z nadpisaniem zeby nie usunąć zapisengo tekstu w pliku
        Write-Output "Computer Name: $env:COMPUTERNAME" | Out-File $raport_name -Append
    }
    elseif ($item.Component -eq "Manufacturer" -and $item.GenerateReport -eq $true){
        #zapsiujemy $info.CsManufacturer do pliku z nadpisaniem zeby nie usunąć zapisengo tekstu w pliku
        Write-Output "Manufacturer: $($info.CsManufacturer)" | Out-File $raport_name -Append
    }
    elseif ($item.Component -eq "Model" -and $item.GenerateReport -eq $true){
        #zapsiujemy $info.CsSystemFamily do pliku z nadpisaniem zeby nie usunąć zapisengo tekstu w pliku
        Write-Output "Model: $($info.CsSystemFamily)" | Out-File $raport_name -Append
    }
    elseif ($item.Component -eq "SerialNumber" -and $item.GenerateReport -eq $true){
        #zapsiujemy $info.OsSerialNumber do pliku z nadpisaniem zeby nie usunąć zapisengo tekstu w pliku
        Write-Output "OsSerialNumber: $($info.OsSerialNumber)" | Out-File $raport_name -Append
    }
    elseif ($item.Component -eq "CpuName" -and $item.GenerateReport -eq $true){
        #zapsiujemy $info.CsProcessors do pliku z nadpisaniem zeby nie usunąć zapisengo tekstu w pliku
        Write-Output "CpuName: $($info.CsProcessors)" | Out-File $raport_name -Append
    }
    elseif ($item.Component -eq "RAM" -and $item.GenerateReport -eq $true){
        #zapsiujemy $info.CsTotalPhysicalMemory do pliku z nadpisaniem zeby nie usunąć zapisengo tekstu w pliku
        Write-Output "RAM: $($info.CsTotalPhysicalMemory / 1GB)GB" | Out-File $raport_name -Append
    }
}

#Get-Location - daje nam lokalizacje gdzie skrypt został uruchomiony
Write-Host "Raport zostal zapisany w pliku: $(Get-Location)\$raport_name"