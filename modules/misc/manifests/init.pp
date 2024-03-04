class misc( $laptop, $desktop ) {

#*******
# Important warning
#*******
  notify { "\n\n\n\nDO NOT change the pagefile size!!  You can disable it on all but one drive, but LEAVE IT SYSTEM MANAGED, or you will get crashes!\n\n\n\n": }

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
    unless_value => 'sShortDate',
    unless_check => 'yyyy-MM-dd',
  }

#**************
# Convert caps lock to ctrl
#**************
  windows_extras::regload { "$wapath/extras/cap_to_ctrl.reg":
    unless_key => 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout',
    unless_check  => '1D003A',
  }

#**************
# Don't run web searches in the windows search menu
#**************
  windows_extras::regload { "$wapath/extras/disable_web_search.reg":
    unless_key => 'HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer',
    unless_value => 'DisableSearchBoxSuggestions',
    unless_check  => '0x1',
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
    ensure => present,
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
    # We specify a version so that the stuff in layout.xml continues to work; alternate solutions welcome.  :)
    ensure => '9.1.105',
  }
  file { "$homepath/AppData/Local/Temp/vim":
    ensure => directory,
  }
  file { "$homepath/.vimrc":
    source => "$wapath/modules/misc/files/vimrc",
    require => File["$homepath/AppData/Local/Temp/vim"],
  }

#**************
# Skype
#**************
  package { 'skype':
    ensure => present,
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
  windows_extras::windows_conditional_symlink_early { "$appdatapath/Audacity/Macros":
    target => "$dbpath/Misc/Audacity_Chains",
    onlyifexists => "$appdatapath/Audacity",
  }


#**************
# LibreOffice
#**************
  package { 'libreoffice':
    ensure => present,
  }

#**************
# Google Drive
#**************
  package { 'googledrive':
    ensure => present,
  }

#**************
# MediaMonkey
#**************
  package { 'mediamonkey':
    ensure => latest,
  }

  # This sets up the M: drive as a sync target for MediaMonkey;
  # see https://superuser.com/questions/29072/how-to-make-subst-mapping-persistent-across-reboots for the registry trick being used here.
  windows_extras::regload { "$wapath/extras/portable_music_drive.reg":
    unless_key   => 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run',
    unless_check => 'M Drive',
    notify      => Reboot['after adding M drive'],
  }
  reboot { 'after adding M drive':
    timeout   => 30,
    message   => 'Puppet will reboot this system in 30 seconds',
    apply     => finished,
  }

#**************
# mp3tag
#**************
  package { 'mp3tag':
    ensure => latest,
  }

#********************************************
# Laptop
#********************************************
  if $laptop {
    windows_extras::regload { "$wapath/extras/keyboard.reg":
      unless_key => 'HKEY_CURRENT_USER\Keyboard Layout\Substitutes',
      unless_check => '00000409',
    }

    $high_perf_power = regsubst("\"$wapath/extras/high_perf_laptop.pow\"", '/', '\\', 'G')
    exec { 'high performance power settings':
      command => "$cmd /c powercfg -S 381b4222-f694-41f0-9685-ff5bb260df2e & $cmd /c powercfg -D 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c & $cmd /c powercfg -import $high_perf_power 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c & cmd /c powercfg -S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c",
    }
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
    ensure => present,
  }
#**************
# Discord
#**************
  package { 'discord.install':
    ensure => present,
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
  windows_extras::windows_symlink_early { "$appdatapath/Factorio":
    target => "$homepath/Dropbox/Games/Factorio",
  }

#**************
# Spore
#**************
  windows_extras::windows_conditional_symlink_early { "$appdatapath/SPORE/Games":
    target => "$homepath/Dropbox/Games/Spore/Games",
    onlyifexists => "$appdatapath/SPORE/",
  }
  windows_extras::windows_conditional_symlink_early { "$appdatapath/SPORE/EditorSaves.package":
    target => "$homepath/Dropbox/Games/Spore/EditorSaves.package",
    onlyifexists => "$appdatapath/SPORE/",
  }
  windows_extras::windows_conditional_symlink_early { "$appdatapath/SPORE/Pollination.package":
    target => "$homepath/Dropbox/Games/Spore/Pollination.package",
    onlyifexists => "$appdatapath/SPORE/",
  }
  windows_extras::windows_symlink_early { "$homepath/Documents/My Spore Creations":
    target => "$homepath/Dropbox/Games/Spore/My Spore Creations",
  }

#**************
# Gnomoria
#**************
  file { ["$homepath/Documents/My Games", "$homepath/Documents/My Games/Gnomoria"]:
    ensure => directory,
  }
  windows_extras::windows_conditional_symlink_early { "$homepath/Documents/My Games/Gnomoria/Worlds":
    target => "$homepath/Dropbox/Games/Gnomoria/Worlds",
    onlyifexists => "$homepath/Documents/My Games/Gnomoria/",
  }

#**************
# Morrowind
#**************
  windows_extras::windows_conditional_symlink_early { "C:/Morrowind/Saves":
    target => "$homepath/Dropbox/Games/Morrowind/Saves",
    onlyifexists => "C:/Morrowind/",
  }
  windows_extras::windows_conditional_symlink_early { "C:/Morrowind/Data Files":
    target => "$homepath/Dropbox/Games/Morrowind/Data Files",
    onlyifexists => "C:/Morrowind/",
  }

#**************
# Freelancer
#**************
  windows_extras::windows_symlink_early { "$homepath/Documents/My Games/Freelancer":
    target => "$homepath/Dropbox/Games/Freelancer",
  }

#**************
# Reus
#**************
  windows_extras::windows_symlink_early { "$homepath/Documents/Reus":
    target => "$homepath/Dropbox/Games/Reus",
  }

#**************
# X3:TC and X3:AP
#**************
  windows_extras::windows_symlink_early { "$homepath/Documents/Egosoft":
    target => "$dbpath/Games/Egosoft",
  }

#**************
# Lichdom and maybe others
#**************
  # We don't need the conditionality here, obviously, but this way
  # it will move the original out of the way if necessary.
  windows_extras::windows_conditional_symlink_early { "$homepath/Saved Games":
    target => "$dbpath/Games/Saved Games",
    onlyifexists => "$homepath/",
  }

#**************
# Hacker Evolution
#**************
  windows_extras::windows_conditional_symlink_early { "$env_programfilesx86/Steam/SteamApps/common/Hacker Evolution/he-savegames":
    target => "$dbpath/Games/Hacker Evolution",
    onlyifexists => "$env_programfilesx86/Steam/SteamApps/common/Hacker Evolution",
  }
  # For the laptop
  windows_extras::windows_conditional_symlink_early { "D:/Steam Storage/steamapps/common/Hacker Evolution/he-savegames":
    target => "$dbpath/Games/Hacker Evolution",
    onlyifexists => "D:/Steam Storage/steamapps/common/Hacker Evolution",
  }

#**************
# Starpoint Gemini 2
#**************
  windows_extras::windows_conditional_symlink_early { "$env_programfilesx86/Steam/SteamApps/common/Starpoint Gemini 2/Saves":
    target => "$dbpath/Games/Starpoint Gemini 2",
    onlyifexists => "$env_programfilesx86/Steam/SteamApps/common/Starpoint Gemini 2",
  }
  # For the laptop
  windows_extras::windows_conditional_symlink_early { "D:/Steam Storage/steamapps/common/Starpoint Gemini 2/Saves":
    target => "$dbpath/Games/Starpoint Gemini 2",
    onlyifexists => "D:/Steam Storage/steamapps/common/Starpoint Gemini 2",
  }

#**************
# FortressCraft Evolved
#**************
  windows_extras::windows_conditional_symlink_early { "$homepath/AppData/LocalLow/ProjectorGames/FortressCraft":
    target => "$dbpath/Games/FortressCraft",
    onlyifexists => "$homepath/AppData/LocalLow/ProjectorGames",
  }

  # Plex *server* is no longer installed locally
  package { 'plexmediaserver':
    ensure => absent,
  }
  file { "$homepath/AppData/Local/Plex Media Server/Metadata":
    ensure => absent,
  }

#**************
# Stardew Valley
#**************
  windows_extras::windows_symlink_early { "$appdatapath/StardewValley":
    target => "$dbpath/Games/StardewValley",
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
  # The windows_extras::windows_conditional_symlink_early here is so much for the
  # conditionality, but so it will move the original out of the way
  # if necessary.
  windows_extras::windows_conditional_symlink_early { "$homepath/Documents/DTP/MyRidingStables/pf_bt1_1.sav":
    require => File["$homepath/Documents/DTP/MyRidingStables"],
    target => "$dbpath/Games/MyRidingStables/pf_bt1_1.sav",
    onlyifexists => "$homepath/Documents/DTP/MyRidingStables/",
  }
  windows_extras::windows_conditional_symlink_early { "$homepath/Documents/DTP/MyRidingStables/pf_bt1_2.sav":
    require => File["$homepath/Documents/DTP/MyRidingStables"],
    target => "$dbpath/Games/MyRidingStables/pf_bt1_2.sav",
    onlyifexists => "$homepath/Documents/DTP/MyRidingStables/",
  }
  windows_extras::windows_conditional_symlink_early { "$homepath/Documents/DTP/MyRidingStables/pf_bt1_3.sav":
    require => File["$homepath/Documents/DTP/MyRidingStables"],
    target => "$dbpath/Games/MyRidingStables/pf_bt1_3.sav",
    onlyifexists => "$homepath/Documents/DTP/MyRidingStables/",
  }
  windows_extras::windows_conditional_symlink_early { "$homepath/Documents/DTP/MyRidingStables/settings.sav":
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
    ensure => absent,
  }

#**************
# License for Chocolatey
#**************
    # Removal:
    #
    # file { "$allusersprofile/chocolatey/license":
    #   ensure => absent,
    #   force  => true,
    #   notify => Exec['remove chocolatey license'],
    # }
    # exec { 'remove chocolatey license':
    #   refreshonly => true,
    #   command     => "$cmd /c choco uninstall -y chocolatey.extension",
    #   logoutput   => true,
    # }
    # Exec['remove chocolatey license'] -> Package <| |>

    # Installation:

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
    ensure => present,
  }


#**************
# Rebel Galaxy
#**************
  file { "$homepath/Documents/My Games/Double Damage Games":
    ensure => directory,
  }
  windows_extras::windows_symlink_early { "$homepath/Documents/My Games/Double Damage Games/RebelGalaxy":
    target => "$homepath/Dropbox/Games/RebelGalaxy-$hostname",
  }

#**************
# SevTech Ages
#**************
  windows_extras::windows_conditional_symlink_early { "$homepath/Twitch/Minecraft/Instances/SevTech Ages/saves":
    target => "$homepath/Dropbox/Games/SevTech_Ages_Saves",
    onlyifexists => "$homepath/Twitch/Minecraft/Instances/SevTech Ages",
  }

#**************
# Siralim 3
#**************
  windows_extras::windows_symlink_early { "$homepath/AppData/Local/Siralim3":
    target => "$homepath/Dropbox/Games/Siralim3",
  }

#**************
# Mindustry
#**************
  windows_extras::windows_conditional_symlink_early { "$env_programfilesx86/Steam/steamapps/common/Mindustry/saves":
    target => "$dbpath/Games/mindustry",
    onlyifexists => "$env_programfilesx86/Steam/SteamApps/common/Mindustry",
  }
  # For the laptop
  windows_extras::windows_conditional_symlink_early { "D:/Steam Storage/steamapps/common/Mindustry/saves":
    target => "$dbpath/Games/mindustry",
    onlyifexists => "D:/Steam Storage/steamapps/common/Mindustry",
  }

#**************
# iTunes Media Library
#
# If this isn't synced then every time you re-OS you have to do crazy things to stop everything from getting wiped
#**************
  windows_extras::windows_symlink_early { "$homepath/Music/iTunes":
    target       => "$dbpath/Misc/iTunes Library",
  }

#**************
# Planetary Annihilation
#**************
  windows_extras::windows_conditional_symlink_early { "$homepath/AppData/Local/Uber Entertainment/Planetary Annihilation":
    target       => "$dbpath/Games/Planetary Annihilation",
    onlyifexists => "$homepath/AppData/Local/Uber Entertainment",
  }

  # No longer needed; goodsync added support for saving auto-sync configs
  file { "$homepath/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/GoodSync.bat":
    ensure => absent,
  }

#**************
# Make Windows wait longer to exit, so GoodSync can complete
#**************
  windows_extras::regload { "$wapath/extras/hung_app_timeout.reg":
    unless_key => 'HKEY_USERS\.DEFAULT\Control Panel\Desktop',
    unless_value => 'HungAppTimeout',
    unless_check  => '300000',
  }

#**************
# Start steam *after* networkking
#**************
  file { "$homepath/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/slow_steam.bat":
    source => "$wapath/extras/slow_steam.bat",
  }

} # end of misc class
