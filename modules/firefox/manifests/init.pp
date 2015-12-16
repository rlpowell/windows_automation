class firefox {
  # Symlinking the profile.ini doesn't work; FF just ignores it
  #
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

  exec { "hard link firefox profiles":
    command => "$cmd /c del $f1 & $cmd /c mklink /h $f1 $f2",
    unless => "$cmd /c findstr cd09hqnd.default $f1",
  }

  file { "$homepath/Desktop/FF Profiles.lnk":
    source => "$wapath/modules/firefox/files/FF Profiles.lnk",
  }

  windows_pin { "$homepath/Desktop/FF Profiles.lnk": type => taskbar }

  exec { "second FF":
    command => "$cmd /c xcopy \"C:\\Program Files (x86)\\Mozilla Firefox\" \"C:\\Program Files (x86)\\Mozilla Firefox Home\\\" /s/h/e/k/f/c/o/y",
    require => Exec["hard link firefox profiles"],
    creates => 'C:\Program Files (x86)\Mozilla Firefox Home',
  }

  file { "$homepath/Desktop/FF Home.lnk":
    source => "$wapath/modules/firefox/files/FF Home.lnk",
  }

  windows_pin { "$homepath/Desktop/FF Home.lnk":
    type => taskbar,
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

  windows_pin { "$homepath/Desktop/FF CB.lnk":
    type => taskbar,
    require => File["$homepath/Desktop/FF CB.lnk"],
  }

  exec { "fix parent.lock":
    command => "$cmd /c $homepath/Dropbox/FireFox/fix_locks.bat >nul 2>&1",
  }

  file { "$appdatapath/Microsoft/Windows/Start Menu/Programs/Startup/FireFox Fix Locks.lnk":
    source => "$homepath/Dropbox/FireFox/FireFox Fix Locks.lnk"
  }

  file { "$homepath/Dropbox/FireFox/fix_locks.bat":
    source => "$wapath/modules/firefox/files/fix_locks.bat",
  }

}
