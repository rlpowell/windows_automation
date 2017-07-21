class misc {
#*******
# Syspin
#*******
  file { 'C:\Windows\System32\syspin.exe':
    source => "$wapath/extras/syspin.exe",
  }

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
  windows_pin { "$dbpath/KiTTY/kitty.exe": type => taskbar }

#**************
# Automation Bash
#**************
  windows_pin { "$wapath/bin/Git Bash.lnk": type => startmenu }

#**************
# Puppet Runs
#**************
  windows_pin { "$wapath/bin/Run Puppet Apply.lnk": type => startmenu }

#**************
# KeePass
#**************
  windows_pin { "$dbpath/keepass/KeePass.exe": type => startmenu }

#**************
# Shut down firefox for dropbox sync
#**************
  windows_pin { "$dbpath/Misc/firefox_stop/FireFox Stop.lnk": type => startmenu }

#**************
# Start Menu And Folder Settings
#**************
  windows_extras::regload { "$wapath/extras/startmenu.reg":
    unless_key => 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    unless_check  => 'Special_Test',
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
  windows_pin { "$env_programdata/Microsoft/Windows/Start Menu/Programs/calibre 64bit - E-book management/calibre 64bit - E-book management.lnk":
    type => startmenu,
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
  windows_pin { "$env_programdata/Microsoft/Windows/Start Menu/Programs/Steam/Steam.lnk":
    type => startmenu,
    require => Package['steam'],
  }
  # Steam Cloud
  #
  # We don't need this to be on dropbox, but putting it there gives
  # us emergency restore options.
  #
  # Not so much for the conditionality, but so it will move the
  # original out of the way if necessary.
  windows_conditional_symlink { "$env_programfilesx86/Steam/userdata":
    target => "$dbpath/Games/Steam_userdata",
    onlyifexists => "$env_programfilesx86/Steam/",
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
  windows_pin { "$env_programdata/Microsoft/Windows/Start Menu/Programs/WinSCP.lnk":
    type => taskbar,
    require => Package['winscp'],
  }

#**************
# vim
#**************
  package { 'vim':
    ensure => installed,
    provider => chocolatey,
  }
  file { "$homepath/AppData/Local/Temp/vim":
    ensure => directory,
  }
  file { "$homepath/.vimrc":
    source => "$wapath/modules/misc/files/vimrc",
    require => File["$homepath/AppData/Local/Temp/vim"],
  }
  if( ! $operatingsystemmajrelease == 10 ) {
    windows_extras::regload { "$wapath/extras/vim.reg":
      require => Package['vim'],
      unless_key => 'HKEY_CLASSES_ROOT\*\shell\Edit with Vim\command',
      unless_check  => 'gvim.bat',
    }
  }

#**************
# Skype
#**************
  package { 'skype':
    ensure => installed,
    provider => chocolatey,
  }
  windows_pin { "$env_programdata/Microsoft/Windows/Start Menu/Programs/Skype/Skype.lnk":
    type => taskbar,
    require => Package['skype'],
  }

#**************
# Flash player for chrome/FF
#**************
  package { 'flashplayerplugin':
    ensure => installed,
    provider => chocolatey,
  }

# Windows 10 start menu searches don't work without the indexing service
#
# #**************
# # Disable search indexing service
# #**************
# service { 'WSearch':
#   ensure => stopped,
#   enable => false,
# }
service { 'WSearch':
  ensure => running,
  enable => true,
}


#**************
# Dropbox Pin
#**************
  windows_pin { "$env_programdata/Microsoft/Windows/Start Menu/Programs/Dropbox/Dropbox.lnk": type => taskbar }

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
  windows_pin { "$env_programfilesx86/Anki/anki.exe":
    type => startmenu,
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
  windows_pin { "$env_programdata/Microsoft/Windows/Start Menu/Programs/Audacity.lnk":
    type => startmenu,
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
  windows_pin { "$dbpath/MediaMonkey/MediaMonkey.exe": type => taskbar }

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
# Digi.me (formerly socialsafe)
#**************
  package { 'digime':
    ensure => installed,
    provider => chocolatey,
  }
  file { "$appdatapath/com.1minus1.socialsafe.D675411CF670AA3EFAC13BDD847989BEDE2115E2.1":
    ensure => "$dbpath/digi.me/com.1minus1.socialsafe.D675411CF670AA3EFAC13BDD847989BEDE2115E2.1",
    require => Package['digime'],
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
  windows_pin { "$wapath/bin/Dropbox Restore.lnk": type => startmenu }
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
#**************
# Telegram
#**************
  package { 'telegram.install':
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
  windows_conditional_symlink { "$appdatapath/SPORE/Games":
    target => "$homepath/Dropbox/Games/Spore/Games",
    onlyifexists => "$appdatapath/SPORE/",
  }
  windows_conditional_symlink { "$appdatapath/SPORE/EditorSaves.package":
    target => "$homepath/Dropbox/Games/Spore/EditorSaves.package",
    onlyifexists => "$appdatapath/SPORE/",
  }
  windows_conditional_symlink { "$appdatapath/SPORE/Pollination.package":
    target => "$homepath/Dropbox/Games/Spore/Pollination.package",
    onlyifexists => "$appdatapath/SPORE/",
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
  windows_conditional_symlink { "$homepath/Documents/My Games/Gnomoria/Worlds":
    target => "$homepath/Dropbox/Games/Gnomoria/Worlds",
    onlyifexists => "$homepath/Documents/My Games/Gnomoria/",
  }

#**************
# Morrowind
#**************
  windows_conditional_symlink { "C:/Morrowind/Saves":
    target => "$homepath/Dropbox/Games/Morrowind/Saves",
    onlyifexists => "C:/Morrowind/",
  }
  windows_conditional_symlink { "C:/Morrowind/Data Files":
    target => "$homepath/Dropbox/Games/Morrowind/Data Files",
    onlyifexists => "C:/Morrowind/",
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
  windows_pin { "$dbpath/Games/Minecraft/Minecraft.exe": type => startmenu }
  windows_pin { "$dbpath/Games/Minecraft/Minecraft Backup.lnk": type => startmenu }

#**************
# X3:TC and X3:AP
#**************
  file { "$homepath/Documents/Egosoft":
    ensure => "$dbpath/Games/Egosoft",
  }

#**************
# Lichdom and maybe others
#**************
  # We don't need the conditionality here, obviously, but this way
  # it will move the original out of the way if necessary.
  windows_conditional_symlink { "$homepath/Saved Games":
    target => "$dbpath/Games/Saved Games",
    onlyifexists => "$homepath/",
  }

#**************
# Hacker Evolution
#**************
  windows_conditional_symlink { "$env_programfilesx86/Steam/SteamApps/common/Hacker Evolution/he-savegames":
    target => "$dbpath/Games/Hacker Evolution",
    onlyifexists => "$env_programfilesx86/Steam/SteamApps/common/Hacker Evolution",
  }

#**************
# Starpoint Gemini 2
#**************
  windows_conditional_symlink { "$env_programfilesx86/Steam/SteamApps/common/Starpoint Gemini 2/Saves":
    target => "$dbpath/Games/Starpoint Gemini 2",
    onlyifexists => "$env_programfilesx86/Steam/SteamApps/common/Starpoint Gemini 2",
  }

#**************
# FortressCraft Evolved
#**************
  windows_conditional_symlink { "$homepath/AppData/LocalLow/ProjectorGames/FortressCraft":
    target => "$dbpath/Games/FortressCraft",
    onlyifexists => "$homepath/AppData/LocalLow/ProjectorGames",
  }

#**************
# MyPhoneExplorer
#
# 18-09:07 <    rlpowell> So, for my future self the next time: For
# android backup/restore, MyPhoneExplorer is like the sync program
# for the old PalmOS, but for Android.
#**************
  windows_pin { "$dbpath/MyPhoneExplorer/MyPhoneExplorer portable.exe": type => startmenu }

## chocolatey package for daemontoolslite is broken
##
## #**************
## # Daemon Tools Lite
## #
## # Used to fake the morrowind CD in our non-existant CD drive
## #**************
##   package { 'daemontoolslite':
##     ensure => installed,
##     provider => chocolatey,
##   }

#**************
# Plex
#**************
  package { 'plexmediaserver':
    ensure => installed,
    provider => chocolatey,
  }
  file { "$homepath/AppData/Local/Plex Media Server/Metadata":
    ensure => "$dbpath/Plex_Metadata",
    require => Package['plexmediaserver'],
  }

#**************
# Ubiquiti UniFi
#**************
  package { 'ubiquiti-unifi-controller':
    ensure => installed,
    provider => chocolatey,
  }
  file { "$homepath/Ubiquiti UniFi/data":
    ensure => "$dbpath/Misc/UniFi_data",
    require => Package['ubiquiti-unifi-controller'],
  }

#**************
# Stardew Valley
#**************
  file { "$appdatapath/StardewValley":
    ensure => "$dbpath/Games/StardewValley",
  }

#**************
# My Riding Stables: Life With Horses (technically My Riding Stables 2)
#**************
  file { "$homepath/Documents/DTP":
    ensure => directory,
  }
  file { "$homepath/Documents/DTP/MyRidingStables":
    ensure => directory,
  }
  # Symlinking the directory makes it crash, but it can only have 3
  # save games, so...
  #
  # Not so much for the conditionality, but so it will move the
  # original out of the way if necessary.
  windows_conditional_symlink { "$homepath/Documents/DTP/MyRidingStables/pf_bt1_1.sav":
    target => "$dbpath/Games/MyRidingStables/pf_bt1_1.sav",
    onlyifexists => "$homepath/Documents/DTP/MyRidingStables/",
  }
  windows_conditional_symlink { "$homepath/Documents/DTP/MyRidingStables/pf_bt1_2.sav":
    target => "$dbpath/Games/MyRidingStables/pf_bt1_2.sav",
    onlyifexists => "$homepath/Documents/DTP/MyRidingStables/",
  }
  windows_conditional_symlink { "$homepath/Documents/DTP/MyRidingStables/pf_bt1_3.sav":
    target => "$dbpath/Games/MyRidingStables/pf_bt1_3.sav",
    onlyifexists => "$homepath/Documents/DTP/MyRidingStables/",
  }

#**************
# FastCopy, RoboCopy type thing but handles hard links better
# From https://ipmsg.org/tools/fastcopy.html.en
#**************
  package { 'fastcopy.portable':
    ensure => installed,
    provider => chocolatey,
  }


#**************
# WinCompose; for writing accents
#**************
  package { 'wincompose':
    ensure => installed,
    provider => chocolatey,
  }

#**************
# Process Explorer; better process monitoring
#**************
  package { 'procexp':
    ensure => installed,
    provider => chocolatey,
  }
  windows_pin { "$env_programdata/chocolatey/bin/procexp64.exe": type => taskbar }

#**************
# WinRAR: archives that respect junctions
#**************
  package { 'winrar':
    ensure => installed,
    provider => chocolatey,
  }

} # end of misc class
