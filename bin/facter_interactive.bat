call "C:\Program Files (x86)\Puppet Labs\Puppet\bin\environment.bat" %0 %*

REM Display Ruby version
ruby.exe -v

REM pause
REM facter --config "C:\Users\rlpowell\Dropbox\Windows_Automation\puppet.conf"
REM pause

puppet facts find localhost --config "C:\Users\rlpowell\Dropbox\Windows_Automation\puppet.conf" --render-as yaml