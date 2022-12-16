$otherScriptName = "Get-NewFreeGames.ps1"
$thisScriptPath = $MyInvocation.MyCommand.Path | Split-Path -Parent
$otherScriptPath = Join-Path $thisScriptPath $otherScriptName
$executionDelayFromStartUp = 10 # in seconds
$taskName = "FreeGamesFinder"
$taskDescription = 'Powershell script that executes on start-up to find new free games'
$taskPath = 'MyCustomTasks'
$onWaitingPressKeyMessage = "`nPress any key to exit."
$onSuccessMessage = 'The script was scheduled correctly'
$onErrorMessage = 'The script could not be scheduled.'

try {
    $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-File `"$otherScriptPath`""
    $trigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay $executionDelayFromStartUp
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Description $taskDescription -TaskPath $taskPath | Out-Null
    Write-Host $onSuccessMessage
} catch {
    Write-Host $onErrorMessage
}

Write-Host $onWaitingPressKeyMessage
$HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | OUT-NULL
$HOST.UI.RawUI.Flushinputbuffer()