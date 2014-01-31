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
# sharpkeys
#**************
  package { 'sharpkeys':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# PuTTY/KiTTY
#**************
  windows_pin_taskbar { "$dbpath/KiTTY/kitty.exe": }

#**************
# Puppet Runs
#**************
  windows_pin_startmenu { "$wapath/bin/Run Puppet Apply.lnk": }

#**************
# Git
#**************
  package { 'git':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# vim
#**************
  file { "$homepath/.vimrc":
    source => "$wapath/modules/misc/files/vimrc",
  }

#**************
# SocialSafe
#**************
  file { "$appdatapath/com.1minus1.socialsafe.D675411CF670AA3EFAC13BDD847989BEDE2115E2.1":
    ensure => "$dbpath/SocialSafe/com.1minus1.socialsafe.D675411CF670AA3EFAC13BDD847989BEDE2115E2.1",
    force => true,
  }

#********************************************
# Games
#********************************************

#**************
# Gnomoria
#**************
  file { "$homepath/Documents/My Games/Gnomoria/Worlds":
    ensure => "$homepath/Dropbox/Games/Gnomoria/Worlds",
    force => true,
  }

#**************
# Freelancer
#**************
  file { "$homepath/Documents/My Games/Freelancer":
    ensure => "$homepath/Dropbox/Games/Freelancer",
    force => true,
  }

}
