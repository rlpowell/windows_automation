class conemu {
  package { 'ConEmu':
    ensure => latest,
  }

  file { "$homepath/Desktop/ConEmu.lnk":
    require => Package['ConEmu'],
    source => "$wapath/modules/conemu/files/conemu.lnk",
  }
}
