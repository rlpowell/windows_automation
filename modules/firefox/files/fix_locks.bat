cd %homepath%\Dropbox\FireFox\Profiles
for /D %%i in (*.*) do del "%%i\parent.lock"
for /D %%i in (*.*) do mklink "%%i\parent.lock" "%appdata%\..\Local\Temp\%%i.parent.lock"
