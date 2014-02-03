include 'stdlib'
#include 'chocolatey'

$homepath="$env_home"
$appdatapath="$env_appdata"
$dbpath="$homepath/Dropbox"
$wapath="$dbpath/Windows_Automation"
$secretspath="$dbpath/Windows_Automation_Secrets"
$cmd='C:\Windows\System32\cmd.exe'

include 'windows_extras'

Exec {
  logoutput => true,
}

File {
  source_permissions => ignore,
}

include 'conemu'
include 'misc'
include 'firefox'
include 'pdfxchange'
include 'secrets'
include 'pictures'

# Laptops
node 'gunka', 'tsetupyzbe' {
  $laptop=true
  $deskop=true
}

# Desktops
node default {
  $laptop=false
  $desktop=true
}
