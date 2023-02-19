"C:\Program Files\Siber Systems\GoodSync\gsync.exe" job-update "F Minecraft PE" /on-file-change=sync /onfilechange-delay=60 /on-timer=sync /timer-period=28 /on-logout=sync
"C:\Program Files\Siber Systems\GoodSync\gsync.exe" job-update Lightroom /on-file-change=sync /onfilechange-delay=60 /on-timer=sync /timer-period=29 /on-logout=sync
"C:\Program Files\Siber Systems\GoodSync\gsync.exe" job-update "Minecraft PE Win 10" /on-file-change=sync /onfilechange-delay=60 /on-timer=sync /timer-period=27 /on-logout=sync

REM Force exit so it reloads the config; may or may not be necessary
REM but the UI doesn't update otherwise.
taskkill /im goodsync.exe
timeout /t 5

REM We have analyze for auto to start taking effect if there have
REM been changes, soooo....
start "" "C:\Program Files\Siber Systems\GoodSync\GoodSync.exe" /tray analyze /all
