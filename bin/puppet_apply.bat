@ECHO OFF

call "C:\Program Files (x86)\Puppet Labs\Puppet\bin\environment.bat" %0 %*

REM Display Ruby version
ruby.exe -v

puppet apply --verbose --config "C:\Users\rlpowell\Dropbox\Windows_Automation\puppet.conf" "C:\Users\rlpowell\Dropbox\Windows_Automation\site.pp"
