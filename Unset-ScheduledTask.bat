@echo off
set scriptlocation="%~dp0"
cd %scriptlocation%
powershell.exe -c "start-process powershell -verb runas -ArgumentList \"-ExecutionPolicy Bypass -command `\"Set-Location $(Get-Location); .\powershell_scripts\Unset-ScheduledTask.ps1`\"\""