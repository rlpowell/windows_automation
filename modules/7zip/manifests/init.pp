class 7zip {
#**************
# 7-Zip
#**************
  package { '7zip':
    ensure => installed,
    provider => chocolatey,
  }

  $unless_key='HKEY_CLASSES_ROOT\.bz2'
  $unless_check='7-zip'
  $unless="$cmd /c reg query \"$unless_key\" | findstr /L \"$unless_check\""

  exec { '7zip associations':
    command => "$cmd /c $wapath\\extras\\7zip_assoc.bat",
    unless => $unless,
  }
}
