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
# Automation Bash
#**************
  windows_pin_startmenu { "$wapath/bin/Git Bash.lnk": }

#**************
# Puppet Runs
#**************
  windows_pin_startmenu { "$wapath/bin/Run Puppet Apply.lnk": }

#**************
# KeePass
#**************
  windows_pin_startmenu { "$dbpath/keepass/KeePass.exe": }

#**************
# Shut down firefox for dropbox sync
#**************
  windows_pin_startmenu { "$dbpath/Misc/firefox_stop/FireFox Stop.lnk": }

#**************
# Start Menu And Folder Settings
#**************
  windows_extras::regload { "$wapath/extras/startmenu.reg":
    # The unless doesn't seem to be working; won't hurt to do it every time.
    #unless_key => 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    #unless_check  => 'HideFileExt',
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
    require => Package['calibre'],
  }
  file { "$appdatapath/calibre":
    ensure => "$dbpath/calibre_configuration",
    require => Package['calibre'],
  }
  windows_pin_startmenu { "$env_programdata/Microsoft/Windows/Start Menu/Programs/calibre - E-book management/calibre - E-book management.lnk":
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
  file { "$appdatapath/WinSCP.ini":
    ensure => "$secretspath/WinSCP.ini",
    require => Package['winscp'],
  }
  windows_pin_taskbar { "$env_programdata/Microsoft/Windows/Start Menu/Programs/WinSCP.lnk":
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
  windows_pin_taskbar { "$env_programdata/Microsoft/Windows/Start Menu/Programs/Skype/Skype.lnk":
    require => Package['skype'],
  }

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
    require => Package['anki'],
  }
  windows_pin_startmenu { "$env_programfilesx86/Anki/anki.exe":
    require => Package['anki'],
  }

#**************
# Audacity
#
# Lamely, LAME must be installed by hand because it refuses robot
# download; use http://lame1.buanzo.com.ar/
#**************
  package { 'audacity':
    ensure => installed,
    provider => chocolatey,
  }
  windows_pin_startmenu { "$env_programdata/Microsoft/Windows/Start Menu/Programs/Audacity.lnk":
    require => Package['audacity'],
  }
  file { "$appdatapath/Audacity/Chains":
    ensure => directory,
    require => Package['audacity'],
  }
  file { "$appdatapath/Audacity/Chains/Louder.txt":
    ensure => "$wapath/extras/Louder.txt",
    require => Package['audacity'],
  }


#**************
# LibreOffice
#**************
  package { 'libreoffice':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# Google Drive
#**************
  package { 'googledrive':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# MediaMonkey
#**************
  windows_pin_taskbar { "$dbpath/MediaMonkey/MediaMonkey.exe": }

  # Set up partially-portable mode, where it can make skin changes
  # and such; see
  # http://www.mediamonkey.com/support/index.php?_m=knowledgebase&_a=viewarticle&kbarticleid=153
  exec { "give admin to mediamonkey":
    command => "$dbpath/MediaMonkey/MediaMonkeyCOM.exe /regserver & $dbpath/MediaMonkey/MediaMonkey.exe \"/elevate /regserver\"",
  }

  # We use mediamonkey sync now.
  #
  ## Set up the M: drive used to sync out media for transfer to my phone
  #$net_use_m_target='\\localhost\C$\Users\rlpowell\Dropbox\Portable Music'
  ## This requires logging off and on to work
  #exec { "mount drive for media monkey portable music writing":
  #  #command => "$cmd /c net use M: /delete & net use M: /persistent:yes \"$net_use_m_target\"",
  #  command => "$cmd /c net use M: /persistent:yes \"$net_use_m_target\"",
  #  unless => "$cmd /c dir M: | findstr /L techno",
  #}

#**************
# mp3tag
#**************
  package { 'mp3tag':
    ensure => installed,
    provider => chocolatey,
  }
#**************
# ffmpeg
#**************
  package { 'ffmpeg':
    ensure => installed,
    provider => chocolatey,
  }
  windows_path {'ffmpeg bin':
    ensure      => present,
    directory   => 'C:\\tools\\ffmpeg\\bin',
  }

#**************
# SocialSafe
#**************
  package { 'socialsafe':
    ensure => installed,
    provider => chocolatey,
  }
  file { "$appdatapath/com.1minus1.socialsafe.D675411CF670AA3EFAC13BDD847989BEDE2115E2.1":
    ensure => "$dbpath/SocialSafe/com.1minus1.socialsafe.D675411CF670AA3EFAC13BDD847989BEDE2115E2.1",
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

#**************
# Dropbox Restore
#**************
  windows_pin_startmenu { "$wapath/bin/Dropbox Restore.lnk": }
  package { 'python2-x86_32':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# VirtualBox
#**************
  package { 'virtualbox':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# Bulk Rename Utility
#**************
  package { 'bulkrenameutility':
    ensure => installed,
    provider => chocolatey,
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
# Factorio
#**************
  file { "$appdatapath/Factorio":
    ensure => "$homepath/Dropbox/Games/Factorio",
  }

#**************
# Spore
#**************
  file { "$appdatapath/SPORE/Games":
    ensure => "$homepath/Dropbox/Games/Spore/Games",
  }
  file { "$appdatapath/SPORE/EditorSaves.package":
    ensure => "$homepath/Dropbox/Games/Spore/EditorSaves.package",
  }
  file { "$appdatapath/SPORE/Pollination.package":
    ensure => "$homepath/Dropbox/Games/Spore/Pollination.package",
  }
  file { "$homepath/Documents/My Spore Creations":
    ensure => "$homepath/Dropbox/Games/Spore/My Spore Creations",
  }

#**************
# Gnomoria
#**************
  file { ["$homepath/Documents/My Games", "$homepath/Documents/My Games/Gnomoria"]:
    ensure => directory,
  }
  file { "$homepath/Documents/My Games/Gnomoria/Worlds":
    ensure => "$homepath/Dropbox/Games/Gnomoria/Worlds",
  }

#**************
# Morrowind
#**************
  file { "C:/Morrowind/Saves":
    ensure => "$homepath/Dropbox/Games/Morrowind",
  }

#**************
# Freelancer
#**************
  file { "$homepath/Documents/My Games/Freelancer":
    ensure => "$homepath/Dropbox/Games/Freelancer",
  }

#**************
# Reus
#**************
  file { "$homepath/Documents/Reus":
    ensure => "$homepath/Dropbox/Games/Reus",
  }

#**************
# Minecraft
#**************
  file { "$appdatapath/.minecraft":
    ensure => "$dbpath/Games/Minecraft",
  }
  windows_pin_startmenu { "$dbpath/Games/Minecraft/Minecraft.exe": }
  windows_pin_startmenu { "$dbpath/Games/Minecraft/Minecraft Backup.lnk": }

#**************
# X3:TC and X3:AP
#**************
  file { "$homepath/Documents/Egosoft":
    ensure => "$dbpath/Games/Egosoft",
  }

#**************
# Lichdom and maybe others
#**************
  file { "$homepath/Saved Games":
    ensure => "$dbpath/Games/Saved Games",
  }

#**************
# Hacker Evolution
#**************
  file { "$env_programfilesx86/Steam/SteamApps/common/Hacker Evolution/he-savegames":
    ensure => "$dbpath/Games/Hacker Evolution",
  }

#**************
# Starpoint Gemini 2
#**************
  file { "$env_programfilesx86/Steam/SteamApps/common/Starpoint Gemini 2/Saves":
    ensure => "$dbpath/Games/Starpoint Gemini 2",
  }

}
