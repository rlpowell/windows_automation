# This module works by using the Local Group Policy to set an XML
# file to (partially) describe Start Menu and Taskbar layouts.
#
# The Start Menu will have groups that the user cannot edit (the user
# can then add and edit their own stuff) and Taskbar items that the
# user can edit but they'll come back if the layout XML file is
# update.
#
# Changes do not take effect until the layout.xml is changed and the user
# re-logs, which is why we force a reboot if it changes.
#
# In the original version we added the XML file to the group policy
# using gpedit.msc, but it turns out we can just stick a copy of the
# rseluting file in a particular place
# (C:\Windows\System32\GroupPolicy\User\Registry.pol) and that's fine,
# which is what the "gpupdate" part is about.
#
# If you need help figuring out how to refer to something in
# layout.xml, set up a new start menu group with the thing that you
# want, go in to powershell and run:
#
#     Export-StartLayout export.xml
#
# Basically, we're following the procedure at
# https://docs.microsoft.com/en-us/windows/configuration/customize-windows-10-start-screens-by-using-group-policy
# , with some tweaks.
#
# Partial reference for the layout.xml file:
#   https://docs.microsoft.com/en-us/windows/configuration/start-layout-xml-desktop
#
# See Also:
#
#   https://4sysops.com/archives/deploy-the-windows-10-start-menu-layout-with-group-policy/#deploying-the-start-menu-layout-via-group-policy
#   https://sccmguru.wordpress.com/2016/08/18/windows-10-1607-taskbar-and-start-customization-deep-dive/
#   https://docs.microsoft.com/en-us/windows/configuration/configure-windows-10-taskbar
#   https://docs.microsoft.com/en-us/windows/configuration/customize-and-export-start-layout
#   https://www.isunshare.com/windows-8/4-ways-to-open-local-group-policy-editor-on-windows-8-8.1.html
#   https://serverfault.com/questions/848388/how-to-edit-local-group-policy-with-script
#
# For why we're using the group policy rather than any other options, see
# https://superuser.com/questions/1117136/import-startlayout-doesnt-change-anything
# and
# https://superuser.com/questions/1331903/how-to-script-my-own-start-menu-and-taskbar
# and
# https://www.reddit.com/r/Windows10/comments/8rwirk/scripted_changes_to_current_users_taskbar_start/
#
#
class layout {
  # This part sets up the actual layout
  file { 'C:\Layout':
    ensure => directory,
  }
  file { [ 'C:\Layout\README.txt', 'C:\Layout\MANAGED_BY_PUPPET.txt' ]:
    content => "Managed by puppet, in the 'layout' module.\n",
  }
  file { 'layout xml':
    path   => 'C:\Layout\layout.xml',
    source => "$wapath/modules/layout/files/layout.xml",
  }
  reboot { 'after layout xml':
    subscribe => [ File['layout xml'], File['group policy'], ],
    timeout   => 30,
    message   => 'Puppet will reboot this system in 30 seconds',
    apply     => finished,
  }

  # This part sets up the local group policy that applies it
  file { 'group policy':
    path   => 'C:\Windows\System32\GroupPolicy\User\Registry.pol',
    source => "$wapath/modules/layout/files/Registry.pol",
    notify => Exec['refresh group policy'],
  }
  # No idea if this is actually needed
  file { 'group policy comment':
    path   => 'C:\Windows\System32\GroupPolicy\User\comment.cmtx',
    source => "$wapath/modules/layout/files/comment.cmtx",
    notify => Exec['refresh group policy'],
  }
  exec { 'refresh group policy':
    refreshonly => true,
    command     => "$cmd /c gpupdate /force",
    notify      => Reboot['after layout xml'],
  }

  # This part puts links where the layout can use them
  file { "$allusersprofile/Microsoft/Windows/Start Menu/Programs/ConEmu (x64).lnk":
    source => "$wapath/extras/ConEmu (x64).lnk",
    notify => Exec['refresh group policy'],
  }
  file { "$allusersprofile/Microsoft/Windows/Start Menu/Programs/kitty.lnk":
    source => "$wapath/extras/kitty.lnk",
    notify => Exec['refresh group policy'],
  }
  file { "$allusersprofile/Microsoft/Windows/Start Menu/Programs/Telegram.lnk":
    source => "$wapath/extras/Telegram.lnk",
    notify => Exec['refresh group policy'],
  }
  file { "$allusersprofile/Microsoft/Windows/Start Menu/Programs/anki.lnk":
    source => "$wapath/extras/anki.lnk",
    notify => Exec['refresh group policy'],
  }
  file { "$allusersprofile/Microsoft/Windows/Start Menu/Programs/KeePass.lnk":
    source => "$wapath/extras/KeePass.lnk",
    notify => Exec['refresh group policy'],
  }
  file { "$allusersprofile/Microsoft/Windows/Start Menu/Programs/MediaMonkey.lnk":
    source => "$wapath/extras/MediaMonkey.lnk",
    notify => Exec['refresh group policy'],
  }
  file { "$allusersprofile/Microsoft/Windows/Start Menu/Programs/Run Puppet Apply.lnk":
    source => "$wapath/bin/Run Puppet Apply.lnk",
    notify => Exec['refresh group policy'],
  }
  file { "$allusersprofile/Microsoft/Windows/Start Menu/Programs/Git Bash.lnk":
    source => "$wapath/bin/Git Bash.lnk",
    notify => Exec['refresh group policy'],
  }
}