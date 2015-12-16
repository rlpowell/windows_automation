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

# Without this, gem install doesn't work
file { "$env_programfiles/Puppet Labs/Puppet/sys/ruby/lib/ruby/site_ruby/2.0.0/rubygems/ssl_certs/AddTrustExternalCARoot-2048.pem":
  source => "$wapath/extras/AddTrustExternalCARoot-2048.pem",
}

class everything {
  include 'misc'
  include 'windows_extras'
  include 'conemu'
  include 'firefox'
  include 'pdfxchange'
  include 'secrets'
  include 'pictures'
  include '7zip'
  include 'path_of_exile'
}

# Laptops
node 'rlp-laptop' {
  $laptop=true
  $deskop=false

  include everything
}

# Desktops
node 'desktop' {
  $laptop=false
  $desktop=true

  include everything
}

