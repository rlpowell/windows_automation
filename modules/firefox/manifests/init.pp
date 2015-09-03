class firefox {
  #file { "$appdatapath/Mozilla/Firefox/profiles.ini":
  #  ensure => "$dbpath/FireFox/profiles.ini",
  #  force => true,
  #}

  $f1_orig = "$appdatapath/Mozilla/Firefox/profiles.ini"
  $f1 = regsubst("\"$f1_orig\"", '/', '\\', 'G')
  $f2 = regsubst("\"$dbpath/FireFox/profiles.ini\"", '/', '\\', 'G')

  package { 'firefox':
    ensure => installed,
    provider => chocolatey,
  }

  file { "$appdatapath/Mozilla":
    ensure => directory,
  }
  file { "$appdatapath/Mozilla/Firefox":
    ensure => directory,
  }

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

  exec { "second FF":
    command => "$cmd /c xcopy \"C:\\Program Files (x86)\\Mozilla Firefox\" \"C:\\Program Files (x86)\\Mozilla Firefox Home\\\" /s/h/e/k/f/c/o/y",
    require => Exec["hard link firefox profiles"],
    creates => 'C:\Program Files (x86)\Mozilla Firefox Home',
  }

  file { "$homepath/Desktop/FF Home.lnk":
    source => "$wapath/modules/firefox/files/FF Home.lnk",
  }

  windows_pin_taskbar { "$homepath/Desktop/FF Home.lnk":
    require => File["$homepath/Desktop/FF Home.lnk"],
  }

  exec { "third FF":
    command => "$cmd /c xcopy \"C:\\Program Files (x86)\\Mozilla Firefox\" \"C:\\Program Files (x86)\\Mozilla Firefox CB\\\" /s/h/e/k/f/c/o/y",
    require => Exec["hard link firefox profiles"],
    creates => 'C:\Program Files (x86)\Mozilla Firefox CB',
  }

  file { "$homepath/Desktop/FF CB.lnk":
    source => "$wapath/modules/firefox/files/FF CB.lnk",
  }

  windows_pin_taskbar { "$homepath/Desktop/FF CB.lnk":
    require => File["$homepath/Desktop/FF CB.lnk"],
  }

  exec { "fix parent.lock":
    command => "$cmd /c $homepath/Dropbox/FireFox/fix_locks.bat",
  }

  file { "$homepath/Dropbox/FireFox/fix_locks.bat",
    source => "$wapath/modules/firefox/files/fix_locks.bat",
  }

}
