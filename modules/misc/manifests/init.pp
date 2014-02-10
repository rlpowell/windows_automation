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
  windows_extras::regload { "$wapath/extras/startmenu.reg":
    unless_key => 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    unless_check  => 'HideFileExt',
  }

#**************
# Language Settings
#**************
  windows_extras::regload { "$wapath/extras/language.reg":
    unless_key => 'HKEY_CURRENT_USER\Control Panel\International',
    unless_check  => 'yyyy-MM-dd',
  }

#**************
# Convert caps lock to ctrl
#**************
  windows_extras::regload { "$wapath/extras/cap_to_ctrl.reg":
    unless_key => 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout',
    unless_check  => '0000000000000000020000001D003A0000000000',
  }

#**************
# VLC
#**************
  package { 'vlc':
    ensure => installed,
    provider => chocolatey,
  }

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
  package { 'kindle':
    ensure => installed,
    provider => chocolatey,
  }
  package { 'calibre':
    ensure => installed,
    provider => chocolatey,
    require => Package['kindle'],
  }
  file { "$homepath/Documents/Calibre Library":
    ensure => "$dbpath/Calibre Library",
    force => true,
    require => Package['calibre'],
  }
  file { "$appdatapath/calibre":
    ensure => "$dbpath/calibre_configuration",
    force => true,
    require => Package['calibre'],
  }
  windows_pin_startmenu { "$env_programdata/Microsoft/Windows/Start Menu/Programs/calibre 64bit - E-book Management/calibre 64bit - E-book Management.lnk":
    require => Package['calibre'],
  }

#**************
# WinDirStat
#**************
  package { 'windirstat':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# Steam
#**************
  package { 'steam':
    ensure => installed,
    provider => chocolatey,
  }
  windows_pin_startmenu { "$env_programdata/Microsoft/Windows/Start Menu/Programs/Steam/Steam.lnk":
    require => Package['steam'],
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
  package { 'vim':
    ensure => installed,
    provider => chocolatey,
  }
  file { "$homepath/.vimrc":
    source => "$wapath/modules/misc/files/vimrc",
  }
  windows_extras::regload { "$wapath/extras/vim.reg":
    require => Package['vim'],
    unless_key => 'HKEY_CLASSES_ROOT\*\shell\Edit with Vim\command',
    unless_check  => 'gvim.bat',
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
# Silverlight
#**************
  package { 'Silverlight':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# FastGlacier
#**************
  package { 'fastglacier':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# Anki
#**************
  package { 'anki':
    ensure => installed,
    provider => chocolatey,
  }
  file { "$homepath/Documents/Anki":
    ensure => "$dbpath/ProgramData/Anki",
    force => true,
    require => Package['anki'],
  }
  windows_pin_startmenu { "$env_programfilesx86/Anki/anki.exe":
    require => Package['anki'],
  }

#**************
# MediaMonkey
  $net_use_m_target='\\localhost\C$\Users\rlpowell\Dropbox\Portable Music'
  # This requires logging off and on to work
  exec { "mount drive for media monkey portable music writing":
    command => "$cmd /c net use M: /delete & net use M: /persistent:yes \"$net_use_m_target\"",
  }

#**************
# SocialSafe
#**************
  # TODO: Actually install.
  file { "$appdatapath/com.1minus1.socialsafe.D675411CF670AA3EFAC13BDD847989BEDE2115E2.1":
    ensure => "$dbpath/SocialSafe/com.1minus1.socialsafe.D675411CF670AA3EFAC13BDD847989BEDE2115E2.1",
    force => true,
  }

#********************************************
# Laptop
#********************************************
  if $laptop {
    windows_extras::regload { "$wapath/extras/keyboard.reg":
      unless_key => 'HKEY_CURRENT_USER\Keyboard Layout\Substitutes',
      unless_check => '00010409',
    }
  
    $high_perf_power = regsubst("\"$wapath/extras/high_perf_laptop.pow\"", '/', '\\', 'G')
    exec { 'high performance power settings':
      command => "$cmd /c powercfg -S 381b4222-f694-41f0-9685-ff5bb260df2e & $cmd /c powercfg -D 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c & $cmd /c powercfg -import $high_perf_power 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c & cmd /c powercfg -S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c",
    }
  }

#********************************************
# Desktop
#********************************************
  if $desktop {
    $high_perf_power = regsubst("\"$wapath/extras/high_perf_desktop.pow\"", '/', '\\', 'G')
    exec { 'high performance power settings':
      command => "$cmd /c powercfg -S 381b4222-f694-41f0-9685-ff5bb260df2e & $cmd /c powercfg -D 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c & $cmd /c powercfg -import $high_perf_power 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c & cmd /c powercfg -S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c",
    }
  }

#********************************************
# Games
#********************************************

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

#**************
# Reus
#**************
  file { "$homepath/Documents/Reus":
    ensure => "$homepath/Dropbox/Games/Reus",
    force => true,
  }

}
