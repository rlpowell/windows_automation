class misc {
#*******
# SSH
#*******
	file { "$homepath/.ssh":
		mode => 770,
		     ensure => directory,
	}

	file { "$homepath/.ssh/id_rsa":
		mode => 440,
		     source => "$secretspath/id_rsa",
	}

	file { "$homepath/.ssh/id_rsa.pub":
		mode => 440,
		     source => "$secretspath/id_rsa.pub",
	}

#**************
# Gnomoria
#**************
	file { "$homepath/Documents/My Games/Gnomoria/Worlds":
		ensure => "$homepath/Dropbox/Games/Gnomoria/Worlds",
		       force => true,
	}

#**************
# SocialSafe
#**************
	file { "$appdatapath/com.1minus1.socialsafe.D675411CF670AA3EFAC13BDD847989BEDE2115E2.1":
		ensure => "$dbpath/SocialSafe/com.1minus1.socialsafe.D675411CF670AA3EFAC13BDD847989BEDE2115E2.1",
		       force => true,
	}

#**************
#**************
}
