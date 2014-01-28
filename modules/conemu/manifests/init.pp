class conemu {
	package { 'ConEmu':
		ensure => installed,
		       provider => 'chocolatey',
	}

	file { "$homepath/Desktop/ConEmu.lnk":
		require => Package['ConEmu'],
			source => "$wapath/modules/conemu/files/conemu.lnk",
	}

	windows_pin_startmenu { "$homepath/Desktop/ConEmu.lnk": }
}
