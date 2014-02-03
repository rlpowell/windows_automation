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
#--- File: 7Zip-Installer.cmd ---
#@echo off
#:Installing
#\\yourcompany.com\software\tools\7z465.exe /S
#:Associate
#assoc .7z=7-Zip.7z
#assoc .bz2=7-Zip.bz2
#assoc .gz=7-Zip.gz
#assoc .tar=7-Zip.tar
#assoc .tgz=7-Zip.tgz
#assoc .zip=7-Zip.zip
#ftype 7-Zip.7z="C:\Program Files\7-Zip\7zFM.exe" "%1"
#ftype 7-Zip.bz2="C:\Program Files\7-Zip\7zFM.exe" "%1"
#ftype 7-Zip.gz="C:\Program Files\7-Zip\7zFM.exe" "%1"
#ftype 7-Zip.tar="C:\Program Files\7-Zip\7zFM.exe" "%1"
#ftype 7-Zip.tgz="C:\Program Files\7-Zip\7zFM.exe" "%1"
#ftype 7-Zip.zip="C:\Program Files\7-Zip\7zFM.exe" "%1"
#
#%distrib_path%\7z465.msi /passive
#xcopy "%distrib_path%\7z.dll" "%ProgramFiles%\7-Zip\&quot; /y /r
#for /d %%A in (7z,arj,bz2,bzip2,cab,cpio,deb,dmg,gz,gzip,hfs,iso,lha,lzh,lzma,rar,rpm,split,swm,tar,taz,tbz,tbz2,tgz,tpz,wim,xar,z,zip) do (
#assoc .%%A=7-zip.%%A
#)
#reg import "%distrib_path%\7z.reg"
#exit
  
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
  windows_pin_startmenu { "$env_programdata/Microsoft/Windows/Start Menu/Programs/Grinding Gear Games/Path of Exile.lnk": }

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
