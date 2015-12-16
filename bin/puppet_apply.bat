@ECHO OFF

call "C:\Program Files\Puppet Labs\Puppet\bin\environment.bat" %0 %*

REM Display Ruby version
ruby.exe -v

echo "" | puppet apply --verbose --config "C:\Users\rlpowell\Dropbox\Windows_Automation\puppet.conf" "C:\Users\rlpowell\Dropbox\Windows_Automation\site.pp"
