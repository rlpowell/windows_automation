class misc( $laptop, $desktop ) {
#*******
# SSH
#*******
  file { "$homepath/.ssh":
    mode => '770',
    ensure => directory,
  }

  file { "$homepath/.ssh/id_rsa":
    mode => '440',
    source => "$secretspath/id_rsa",
  }

  file { "$homepath/.ssh/id_rsa.pub":
    mode => '440',
    source => "$secretspath/id_rsa.pub",
  }

#**************
# sharpkeys
#**************
  package { 'sharpkeys':
    ensure => latest,
  }

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
    ensure => latest,
  }

#**************
# Java
#**************
  package { 'javaruntime':
    ensure => latest,
  }

#**************
# Calibre
#**************
  package { 'kindle':
    # More recent versions don't work with DeDRM.  Note that
    # actually being able to download this requires Chocolatey Pro,
    # because it uses the Chocolatey CDN (the 1.17 version doesn't
    # download properly from its original source anymore).
    ensure   => '1.17',
  }
  package { 'calibre':
    ensure => latest,
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

#**************
# WinDirStat
#**************
  package { 'windirstat':
    ensure => latest,
  }

#**************
# Steam
#**************
  package { 'steam':
    ensure => latest,
  }

  # Steam Cloud
  #
  # We don't need this to be on dropbox, but putting it there gives
  # us emergency restore options.  We do it per-machine because
  # otherwise (1) we get annoying messages and (2) we may or may not
  # be able to do per-machine per-game settings properly.
  #
  # The windows_conditional_symlink here is so much for the
  # conditionality, but so it will move the original out of the way
  # if necessary.
  windows_conditional_symlink { "$env_programfilesx86/Steam/userdata":
    target => "$dbpath/Games/Steam_userdata-$hostname",
    onlyifexists => "$env_programfilesx86/Steam/",
  }


#**************
# Git
#**************
  package { 'git':
    ensure => latest,
  }
  file { "$homepath/.gitconfig":
    source => "$wapath/extras/gitconfig",
  }

#**************
# WinSCP
#**************
  package { 'winscp':
    ensure => latest,
  }
  file { "$appdatapath/WinSCP.ini":
    ensure => "$secretspath/WinSCP.ini",
    require => Package['winscp'],
  }

#**************
# vim
#**************
  package { 'vim':
    ensure => latest,
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
    ensure => latest,
  }

#**************
# Flash player for chrome/FF
#**************
  package { 'flashplayerplugin':
    ensure => latest,
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
# Silverlight
#**************
  package { 'Silverlight':
    ensure => latest,
  }

#**************
# FastGlacier
#**************
  package { 'fastglacier':
    ensure => latest,
  }

#**************
# Anki
#**************
  package { 'anki':
    ensure => latest,
  }
  file { "$homepath/Documents/Anki":
    ensure => "$dbpath/ProgramData/Anki",
    require => Package['anki'],
  }

#**************
# Audacity
#
# Lamely, LAME must be installed by hand because it refuses robot
# download; use http://lame1.buanzo.com.ar/
#**************
  package { [ 'audacity', 'audacity-lame']:
    ensure => latest,
  }
  windows_conditional_symlink { "$appdatapath/Audacity/Macros":
    target => "$dbpath/Misc/Audacity_Chains",
    onlyifexists => "$appdatapath/Audacity",
  }


#**************
# LibreOffice
#**************
  package { 'libreoffice':
    ensure => latest,
  }

#**************
# Google Drive
#**************
  package { 'googledrive':
    ensure => latest,
  }

#**************
# MediaMonkey
#**************
  # Set up partially-portable mode, where it can make skin changes
  # and such; see
  # http://www.mediamonkey.com/support/index.php?_m=knowledgebase&_a=viewarticle&kbarticleid=153
  exec { "give admin to mediamonkey":
    command => "$dbpath/MediaMonkey/MediaMonkeyCOM.exe /regserver & $dbpath/MediaMonkey/MediaMonkey.exe \"/elevate /regserver\"",
  }

#**************
# mp3tag
#**************
  package { 'mp3tag':
    ensure => latest,
  }
#**************
# ffmpeg
#**************
  package { 'ffmpeg':
    ensure => latest,
  }
  windows_path {'ffmpeg bin':
    ensure      => present,
    directory   => 'C:\\tools\\ffmpeg\\bin',
  }

#**************
# Digi.me (formerly socialsafe)
#**************
  package { 'digime-2':
    ensure => latest,
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
  package { 'python2':
    ensure => latest,
  }

#**************
# VirtualBox
#**************
  package { 'virtualbox':
    ensure => latest,
  }

#**************
# Bulk Rename Utility
#**************
  package { 'bulkrenameutility':
    ensure => latest,
  }
#**************
# Telegram
#**************
  package { 'telegram.install':
    ensure => latest,
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
# Plex
#**************
  package { 'plexmediaserver':
    ensure => latest,
  }
  file { "$homepath/AppData/Local/Plex Media Server/Metadata":
    ensure => "$dbpath/Plex_Metadata",
    require => Package['plexmediaserver'],
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
    require => File["$homepath/Documents/DTP"],
    ensure => directory,
  }
  # Symlinking the directory makes it crash, but it can only have 3
  # save games, so...
  #
  # The windows_conditional_symlink here is so much for the
  # conditionality, but so it will move the original out of the way
  # if necessary.
  windows_conditional_symlink { "$homepath/Documents/DTP/MyRidingStables/pf_bt1_1.sav":
    require => File["$homepath/Documents/DTP/MyRidingStables"],
    target => "$dbpath/Games/MyRidingStables/pf_bt1_1.sav",
    onlyifexists => "$homepath/Documents/DTP/MyRidingStables/",
  }
  windows_conditional_symlink { "$homepath/Documents/DTP/MyRidingStables/pf_bt1_2.sav":
    require => File["$homepath/Documents/DTP/MyRidingStables"],
    target => "$dbpath/Games/MyRidingStables/pf_bt1_2.sav",
    onlyifexists => "$homepath/Documents/DTP/MyRidingStables/",
  }
  windows_conditional_symlink { "$homepath/Documents/DTP/MyRidingStables/pf_bt1_3.sav":
    require => File["$homepath/Documents/DTP/MyRidingStables"],
    target => "$dbpath/Games/MyRidingStables/pf_bt1_3.sav",
    onlyifexists => "$homepath/Documents/DTP/MyRidingStables/",
  }
  windows_conditional_symlink { "$homepath/Documents/DTP/MyRidingStables/settings.sav":
    require => File["$homepath/Documents/DTP/MyRidingStables"],
    target => "$dbpath/Games/MyRidingStables/settings.sav",
    onlyifexists => "$homepath/Documents/DTP/MyRidingStables/",
  }

#**************
# FastCopy, RoboCopy type thing but handles hard links better
# From https://ipmsg.org/tools/fastcopy.html.en
#**************
  package { 'fastcopy.portable':
    ensure => latest,
  }


#**************
# WinCompose; for writing accents on the dvorak keyboard
#**************
  package { 'wincompose':
    ensure => latest,
  }

#**************
# Process Explorer; better process monitoring
#**************
  package { 'procexp':
    ensure => latest,
  }

#**************
# WinRAR: archives that respect junctions
#**************
  package { 'winrar':
    ensure => latest,
  }
  file { "$appdatapath/WinRAR/rarreg.key":
    ensure  => "$secretspath/rarreg.key",
    require => Package['winrar'],
  }

#**************
# Checksum for use in Chocolatey
#**************
  package { 'checksum':
    ensure => latest,
  }

#**************
# TeamViewer
#**************
  package { 'teamviewer':
    ensure => latest,
  }

#**************
# License for Chocolatey
#**************
  file { "$allusersprofile/chocolatey/license":
    ensure => directory,
  }
  file { "$allusersprofile/chocolatey/license/chocolatey.license.xml":
    ensure => "$secretspath/chocolatey.license.xml",
    notify => Exec['install chocolatey license'],
  }
  exec { 'install chocolatey license':
    refreshonly => true,
    command     => "$cmd /c choco upgrade -y chocolatey.extension",
    logoutput   => true,
  }

#**************
# Slack
#**************
  package { 'slack':
    ensure => latest,
  }


#**************
# Rebel Galaxy
#**************
  file { "$homepath/Documents/My Games/Double Damage Games":
    ensure => directory,
  }
  file { "$homepath/Documents/My Games/Double Damage Games/RebelGalaxy":
    target => "$homepath/Dropbox/Games/RebelGalaxy-$hostname",
  }

} # end of misc class
