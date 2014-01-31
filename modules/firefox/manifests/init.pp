class firefox {
  #file { "$appdatapath/Mozilla/Firefox/profiles.ini":
  #  ensure => "$dbpath/FireFox/profiles.ini",
  #  force => true,
  #}

  $f1_orig = "$appdatapath/Mozilla/Firefox/profiles.ini"
  $f1 = regsubst("\"$f1_orig\"", '/', '\\', 'G')
  $f2 = regsubst("\"$dbpath/FireFox/profiles.ini\"", '/', '\\', 'G')

  # mklink can't overwrite, so we have to kill and re-create every freaking time; not sure how else to tell the file is in place
  file { "$f1_orig":
    ensure => absent,
  }
  exec { "hard link firefox profiles":
    command => "$cmd /c mklink /h $f1 $f2",
    require => File[$f1_orig],
  }

  file { "$homepath/Desktop/FF Profiles.lnk":
    source => "$wapath/modules/firefox/files/FF Profiles.lnk",
  }

  windows_pin_taskbar { "$homepath/Desktop/FF Profiles.lnk": }
}
