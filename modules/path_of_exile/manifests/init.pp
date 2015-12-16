class path_of_exile {
#**************
# Path Of Exile
#**************
  package { 'pathofexile':
    ensure => installed,
    provider => chocolatey,
  }
  windows_pin { "$env_programdata/Microsoft/Windows/Start Menu/Programs/Grinding Gear Games/Path of Exile.lnk": type => startmenu }

  if $laptop {
    file { "$homepath/Documents/My Games/Path of Exile/production_Config.ini":
      ensure => "$wapath/extras/poe_laptop.ini",
      force => true,
    }
  }
  if $desktop {
    file { "$homepath/Documents/My Games/Path of Exile/production_Config.ini":
      ensure => "$wapath/extras/poe_desktop.ini",
      force => true,
    }
  }
}
