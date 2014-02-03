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
# KeePass
#**************
  windows_pin_startmenu { "$dbpath/keepass/KeePass.exe": }

#**************
# Start Menu And Folder Settings
#**************
  windows_extras::regload { "$wapath/extras/startmenu.reg": }

#**************
# Language Settings
#**************
  windows_extras::regload { "$wapath/extras/language.reg": }

#**************
# Convert caps lock to ctrl
#**************
  windows_extras::regload { "$wapath/extras/cap_to_ctrl.reg": }

#**************
# Printer; Requires Human
#**************
  exec { 'kick off printer install':
    command => "$cmd /c $wapath/extras/md6l-win-mx700-1_02-en.exe",
    unless => "$cmd /c wmic printer list status | findstr /C:\"Canon MX700 series Printer\"",
  }

#**************
# Java
#**************
  package { 'javaruntime':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# Calibre
#**************
  package { 'calibre':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# WinDirStat
#**************
  package { 'windirstat':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# 7-Zip
#**************
  package { '7zip':
    ensure => installed,
    provider => chocolatey,
  }
  
#**************
# Git
#**************
  package { 'git':
    ensure => installed,
    provider => chocolatey,
  }
  file { "$homepath/.gitconfig":
    source => "$wapath/extras/gitconfig",
  }

#**************
# WinSCP
#**************
  package { 'winscp':
    ensure => installed,
    provider => chocolatey,
  }
  file { "C:/Chocolatey/bin/WinSCP.ini":
    source => "$secretspath/WinSCP.ini",
    require => Package['winscp'],
  }

#**************
# vim
#**************
  file { "$homepath/.vimrc":
    source => "$wapath/modules/misc/files/vimrc",
  }
  windows_extras::regload { "$wapath/extras/vim.reg":
    unless  => "$cmd /c reg query \"HKEY_CLASSES_ROOT\\*\\shell\\Edit with Vim\\command\" | findstr /C:gvim.bat",
  }

#**************
# Skype
#**************
  package { 'skype':
    ensure => installed,
    provider => chocolatey,
  }
  windows_pin_taskbar { "$env_programdata/Microsoft/Windows/Start Menu/Programs/Skype/Skype.lnk": }

#**************
# Flash player for chrome/FF
#**************
  package { 'flashplayerplugin':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# Disable search indexing service
#**************
service { 'WSearch':
  ensure => stopped,
  enable => false,
}

#**************
# Dropbox Pin
#**************
  windows_pin_taskbar { "$appdatapath/Microsoft/Windows/Start Menu/Programs/Dropbox/Dropbox.lnk": }

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
# Path Of Exile
#**************
  package { 'pathofexile':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# Gnomoria
#**************
  file { ["$homepath/Documents/My Games", "$homepath/Documents/My Games/Gnomoria"]:
    ensure => directory,
  }
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
