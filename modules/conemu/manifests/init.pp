class conemu {
  package { 'ConEmu':
    ensure => installed,
  }

  file { "$homepath/Desktop/ConEmu.lnk":
    require => Package['ConEmu'],
    source => "$wapath/modules/conemu/files/conemu.lnk",
  }

  windows_pin { "$homepath/Desktop/ConEmu.lnk": type => startmenu }
}
