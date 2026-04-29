#wczytujemy plik csv i ustawiamy delimiter jako ;
$file = Import-Csv -Delimiter ";" .\input_file.csv

#zapisujemy Get-ComputerInfo do zmiennej by usprawnić wczytywanie infoamcji o komputerze
$info = Get-ComputerInfo


Write-Host "RAPORT"

#iterujmy nasz plik csv po każdym wierszu
foreach ($item in $file){
    #sprawdza czy przy danym wierszu ma coś wartość true a nastepnie genruje raport na tej podstawie
    #$item.Component jest to np.Computername | $item.GenerateReport jest to true lub false
    if ($item.Component -eq "Computername" -and $item.GenerateReport -eq $true){
        #$env:COMPUTERNAME - nazwa komputera w którym skrypt jest puszczony
        Write-Host "Computer Name: $env:COMPUTERNAME"
    }
    elseif ($item.Component -eq "Manufacturer" -and $item.GenerateReport -eq $true){
        #$info.CsManufacturer - bierze z get-computerinfo tylko wartosc z zmiennej CsManufacturer
        Write-Host "Manufacturer: $($info.CsManufacturer)"
    }
    elseif ($item.Component -eq "Model" -and $item.GenerateReport -eq $true){
        #$info.CsSystemFamily - bierze z get-computerinfo tylko wartosc z zmiennej CsSystemFamily
        Write-Host "Model: $($info.CsSystemFamily)"
    }
    elseif ($item.Component -eq "SerialNumber" -and $item.GenerateReport -eq $true){
        #$info.OsSerialNumber - bierze z get-computerinfo tylko wartosc z zmiennej OsSerialNumber
        Write-Host "OsSerialNumber: $($info.OsSerialNumber)"
    }
    elseif ($item.Component -eq "CpuName" -and $item.GenerateReport -eq $true){
        #$info.CsProcessors - bierze z get-computerinfo tylko wartosc z zmiennej CsProcessors
        Write-Host "CpuName: $($info.CsProcessors)"
    }
    elseif ($item.Component -eq "RAM" -and $item.GenerateReport -eq $true){
        #$info.CsTotalPhysicalMemory - bierze z get-computerinfo tylko wartosc z zmiennej CsTotalPhysicalMemory i dzielimy go przez 1GB poniewaz jest zapisany w bitach
        Write-Host "RAM: $($info.CsTotalPhysicalMemory / 1GB)GB"
    }
}