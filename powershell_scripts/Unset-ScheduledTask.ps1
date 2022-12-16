$taskName = "FreeGamesFinder"
$taskPath = 'MyCustomTasks'
$onWaitingPressKeyMessage = "`nPress any key to exit."
$onSuccessMessage = 'The script was unscheduled correctly'
$onErrorMessage = 'The script could not be unscheduled.'

try {
    # removes the task
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false | Out-Null

    #removes the task's parent folder
    $scheduleObject = New-Object -ComObject Schedule.Service
    $scheduleObject.connect()
    $rootFolder = $scheduleObject.GetFolder('\')
    $rootFolder.DeleteFolder($taskPath, $null)

    Write-Host $onSuccessMessage
}
catch {
    Write-Host $onErrorMessage
}


Write-Host $onWaitingPressKeyMessage
$HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | OUT-NULL
$HOST.UI.RawUI.Flushinputbuffer()