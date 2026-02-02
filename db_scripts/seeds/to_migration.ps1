#Pegar o diretório atual
$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

#Arquivo saída com todos sql
$outputFile = Join-Path -Path $scriptDirectory -ChildPath "migration.sql"

#Verifica se arquivo já existe, se existir deleta
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

#Pegar o conteúdo dos arquivos
$sqlFiles = Get-ChildItem -Path $scriptDirectory -Filter *.sql -File | Sort-Object Name

#Concatena arquivos
foreach($file in $sqlfiles){
    Get-Content $file.FullName | Out-File -Append -FilePath $outputFile -Encoding utf8
    "`nGO`n" | Out-File -Append -FilePath $outputFile -Encoding utf8
}

Write-Host "Todos os arquivos foram combinados em $outputFile"
