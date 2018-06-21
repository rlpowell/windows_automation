include stdlib

$homepath="$env_home"
$appdatapath="$env_appdata"
$allusersprofile="$env_allusersprofile"
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

case $operatingsystem {
  'windows': {
    Package { provider => chocolatey, }
  }
}

# Seems to have been fixed
# 
# # Without this, gem install doesn't work
# file { "$rubysitedir/rubygems/ssl_certs/AddTrustExternalCARoot-2048.pem":
#   source => "$wapath/extras/AddTrustExternalCARoot-2048.pem",
# }

class everything( $laptop, $desktop ) {
  class { 'misc':
    laptop  => $laptop,
    desktop => $desktop,
  }

  include 'windows_extras'
  include 'conemu'
  include 'firefox'
  include 'pdfxchange'
  include 'secrets'
  include 'pictures'
  # We handle this manually so we can copy the content over
  # include 'path_of_exile'
}

# Laptops
node 'rlp-laptop', 'rlp-lenovo-p71' {
  class { 'everything':
    laptop  => true,
    desktop => false,
  }
}

# Desktops
node 'rlp-desktop' {
  class { 'everything':
    laptop  => false,
    desktop => true,
  }
}

