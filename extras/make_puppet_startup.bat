:: This script was created by Matthew Wai at TenForums.com/members/matthew-wai.html
:: http://www.tenforums.com/tutorials/57690-create-elevated-shortcut-without-uac-prompt-windows-10-a.html
::
:: Heavily modified for my use for a puppet startup link
:: ************************************************************************************/
:: @echo off & Title Create an elevated shortcut without a UAC prompt & mode con cols=90 lines=22 & color 17
(Net session >nul 2>&1)||(PowerShell start """%~0""" -verb RunAs & Exit /B) 
:: ************************************************************************************/
cd /d "%~dp0"
:: @ECHO OFF & setlocal
SET "[Name]=Puppet"
Set "[Path]=""C:\Users\rlpowell\Dropbox\Windows_Automation\bin\puppet_apply.bat"""
:: ************************************************************************************/
For /f "tokens=*" %%I in ('WhoAmI /user') Do (for %%A in (%%~I) Do (set "[SID]=%%A"))
Set "[Task_name]=%[Name]: =_%"	
IF EXIST "%temp%\%[Task_name]%.xml" (DEL "%temp%\%[Task_name]%.xml")	
IF EXIST "%temp%\Task.vbs" (DEL "%temp%\Task.vbs")	

echo Set X=CreateObject("Scripting.FileSystemObject") >> "%temp%\Task.vbs"
echo Set Z=X.CreateTextFile("%temp%\%[Task_name]%.xml",True,True)>> "%temp%\Task.vbs"
Set "W=echo Z.writeline "	
(
%W%"<?xml version=""1.0"" encoding=""UTF-16""?>"
%W%"<Task version=""1.4"" xmlns=""http://schemas.microsoft.com/windows/2004/02/mit/task"">"
%W%"<RegistrationInfo>"
%W%"<Author>%username%</Author>"
%W%"<Description>To run the application/CMD script as an administrator with no UAC prompt.</Description>"
%W%"</RegistrationInfo>"
%W%"<Triggers />"
%W%"<Principals>"
%W%"<Principal id=""Author"">"
%W%"<UserId>%[SID]%</UserId>"
%W%"<LogonType>InteractiveToken</LogonType>"
%W%"<RunLevel>HighestAvailable</RunLevel>"
%W%"</Principal>"
%W%"</Principals>"
%W%"<Settings>"
%W%"<MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>"
%W%"<DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>"
%W%"<StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>"
%W%"<AllowHardTerminate>true</AllowHardTerminate>"
%W%"<StartWhenAvailable>false</StartWhenAvailable>"
%W%"<RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>"
%W%"<IdleSettings>"
%W%"<StopOnIdleEnd>true</StopOnIdleEnd>"
%W%"<RestartOnIdle>false</RestartOnIdle>"
%W%"</IdleSettings>"
%W%"<AllowStartOnDemand>true</AllowStartOnDemand>"
%W%"<Enabled>true</Enabled>"
%W%"<Hidden>false</Hidden>"
%W%"<RunOnlyIfIdle>false</RunOnlyIfIdle>"
%W%"<DisallowStartOnRemoteAppSession>false</DisallowStartOnRemoteAppSession>"
%W%"<UseUnifiedSchedulingEngine>true</UseUnifiedSchedulingEngine>"
%W%"<WakeToRun>false</WakeToRun>"
%W%"<ExecutionTimeLimit>PT72H</ExecutionTimeLimit>"
%W%"<Priority>7</Priority>"
%W%"</Settings>"
%W%"<Actions Context=""Author"">"
%W%"<Exec>"
%W%"<Command>cmd.exe</Command>"
%W%"<Arguments>/c start ""%[Name]%"" " ^& """%[Path]%""" ^& "</Arguments>"
%W%"</Exec>"
%W%"</Actions>"
%W%"</Task>"
)>> "%temp%\Task.vbs"
echo Z.Close >> "%temp%\Task.vbs"
"%temp%\Task.vbs"
Del "%temp%\Task.vbs"	
schtasks /create /xml "%temp%\%[Task_name]%.xml" /tn "Apps\%[Task_name]%"
If errorlevel 1 (DEL "%temp%\%[Task_name]%.xml" & echo.
echo  =======================================================================================
echo     The script has failed to create the task. You may have entered a name already 
echo     used in Task Scheduler or a name containing special characters/punctuation marks.
echo     Otherwise, you may have entered a file path that contains special characters or 
echo     punctuation marks. Please re-run the script and enter a different/valid name/file
echo     path. Press any key to close this message. 
echo  =======================================================================================
pause > nul) else (DEL "%temp%\%[Task_name]%.xml")
 
IF EXIST "%temp%\Shortcut.vbs" (DEL "%temp%\Shortcut.vbs")	
(echo Set A = CreateObject^("WScript.Shell"^) & echo Set B = A.CreateShortcut^("C:\Users\rlpowell\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\%[Name]%.lnk"^) & echo B.IconLocation = "%[Path]%" & echo B.TargetPath = "%windir%\System32\schtasks.exe" & echo B.Arguments = "/run /tn ""Apps\%[Task_name]%""" & echo B.Save & echo WScript.Quit)> "%temp%\Shortcut.vbs"
"%temp%\Shortcut.vbs"	

If errorlevel 1 (echo.
echo  ====================================================================================
echo      The script has failed to complete the operation.
echo      Please press any key to close this message.
echo  ====================================================================================
pause > nul) else (echo.
echo  ====================================================================================
echo      The shortcut "%[Name]%" has been created in the startup folder.
echo  ====================================================================================
pause > nul)
