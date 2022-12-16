@echo off
set scriptlocation="%~dp0"
cd %scriptlocation%
powershell.exe -c "start-process powershell -verb runas -ArgumentList \"-command `\"Set-Location $(Get-Location); .\powershell_scripts\Set-ScheduledTask.ps1`\"\""