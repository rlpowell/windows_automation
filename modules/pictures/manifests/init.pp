class pictures {
  package { [ 'picasa', 'irfanview', 'photoguru', 'quicktime' ]:
    ensure => installed,
    provider => chocolatey,
  }

  windows_pin { "$dbpath/Misc/zenfolio/Pictures Pre Sorting.lnk":
    type => startmenu,
    require => Package['picasa', 'photoguru'],
  }
  windows_pin { "$env_programdata/Microsoft/Windows/Start Menu/Programs/Picasa 3/Picasa 3.lnk":
    type => startmenu,
    require => Windows_pin["$dbpath/Misc/zenfolio/Pictures Pre Sorting.lnk"],
  }
  windows_pin { "$env_programdata/Microsoft/Windows/Start Menu/Programs/Photo Guru/Photo Guru Backup.lnk":
    type => startmenu,
    require => Windows_pin["$env_programdata/Microsoft/Windows/Start Menu/Programs/Picasa 3/Picasa 3.lnk"],
  }
  windows_pin { "$dbpath/Misc/zenfolio/Pictures Post Upload.lnk":
    type => startmenu,
    require => Windows_pin["$env_programdata/Microsoft/Windows/Start Menu/Programs/Photo Guru/Photo Guru Backup.lnk"],
  }
  windows_pin { "$dbpath/Misc/zenfolio/Pictures Rebuild Collections.lnk":
    type => startmenu,
    require => Windows_pin["$env_programdata/Microsoft/Windows/Start Menu/Programs/Photo Guru/Photo Guru Backup.lnk"],
  }

  file { "$appdatapath/../Local/Google/Picasa2":
    ensure => "$dbpath/ProgramData/Picasa2",
    require => Package['picasa'],
  }
  file { "$appdatapath/../Local/Google/Picasa2Albums":
    ensure => "$dbpath/ProgramData/Picasa2Albums",
    require => Package['picasa'],
  }

  windows_extras::regload { "$secretspath/picasa_options.reg":
    require => File["$appdatapath/../Local/Google/Picasa2"],
    unless_key => 'HKEY_CURRENT_USER\Software\Google\Picasa\Picasa2\Preferences',
    unless_check  => 'captionmode',
  }

  package { [ 'highline', 'inifile', 'exifr', 'nokogiri', 'htmlentities', 'iptc' ]:
    ensure => installed,
    provider => gem,
  }
}
