include 'stdlib'
#include 'chocolatey'

$homepath="$env_home"
$appdatapath="$env_appdata"
$dbpath="$homepath/Dropbox"
$wapath="$dbpath/Windows_Automation"
$secretspath="$dbpath/Windows_Automation_Secrets"
$cmd='C:\Windows\System32\cmd.exe'

Exec {
  logoutput => true,
}

File {
  source_permissions => ignore,
}

class everything {
  include 'windows_extras'
  include 'conemu'
  include 'misc'
  include 'firefox'
  include 'pdfxchange'
  include 'secrets'
  include 'pictures'
  include '7zip'
  include 'path_of_exile'
}

# Laptops
node 'gunka', 'tsetupyzbe' {
  $laptop=true
  $deskop=false

  include everything
}

# Desktops
node default {
  $laptop=false
  $desktop=true

  include everything
}

