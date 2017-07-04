$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$packageName"

Install-ChocolateyZipPackage 'pdfxchangelite-zip' 'http://downloads.pdf-xchange.com/PDFXLite6.zip' $tempDir -Checksum '31843332C22BA0FE837419BFF561880E2A685739BB2199B931FA8F4168658F69' -ChecksumType 'sha256'
Install-ChocolateyInstallPackage 'pdfxchangelite' 'exe' '/SILENT /NORESTART' "$tempDir\PDFXLite6.exe" -validExitCodes @(0,3010)
