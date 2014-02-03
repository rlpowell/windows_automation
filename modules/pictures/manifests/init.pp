class pictures {
  package { [ 'picasa', 'irfanview', 'rubygems' ]:
    ensure => installed,
    provider => chocolatey,
  }

  windows_pin_startmenu { "$dbpath/Misc/zenfolio/Pictures Pre Sorting.lnk": }
  windows_pin_startmenu { "$dbpath/Misc/zenfolio/Pictures Post Upload.lnk":
    require => Windows_pin_startmenu["$dbpath/Misc/zenfolio/Pictures Pre Sorting.lnk"],
  }

  package { [ 'highline' ]:
    ensure => installed,
    provider => gem,
    require => Package['rubygems'],
  }
}
