@echo off
set scriptlocation="%~dp0"
cd %scriptlocation%
powershell.exe -c "start-process powershell -ArgumentList \"-command `\"Set-Location $(Get-Location); .\powershell_scripts\Get-NewFreeGames.ps1`\"\""