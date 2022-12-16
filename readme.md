# Free Games Finder

This script finds new games comparing the previous execution with the new one.

All the data is requested from the API: <https://www.gamerpower.com/api/giveaways>

The included scripts *Set-ScheduledTask.ps1* and *Unset-ScheduledTask.ps1* allow to set or remove its execution from PC start-up.

After any execution of the *Get-NewFreeGames* script, two .csv files will be generated inside the powershell_scripts folder.

One of them (*new_games.csv*) has the new games found since the last execution. The other file contains the whole data of the last execution and it's needed on future executions (if deleted, then EVERY game will be shown, with no comparison).

## Usage

First, create a folder somewhere and put every single file inside (don't ever move that folder).

After that, just doble click any of the .bat files and accept the emerging window to execute powershell as admin (needed to set and unset the task on the scheduler).

There is a file called *Set-ScheduledTask.ps1* inside the *powershell_scripts* folder. The value on this line can be changed to delay the script execution on PC start-up:

```powershell
    $executionDelayFromStartUp = 10 # in seconds
```

On the same folder, the file called *Get-NewFreeGames.ps1* can have this line modified to filter by specific platforms:

```powershell
    # Sample values: 'PC', 'DRM-Free', 'Steam', 'Android', 'PlayStation', 'Xbox', 'Gog', 'Itch.io', 'iOS'
    $platformFilter = @() #@('pc', 'android') <- write as many platforms as needed just like this
```

## Troubleshooting

If you can't execute powershell scripts or haven't ever done it before, open powershell and execute this line:

```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

If after this fix the scripts can't be run yet, then do this to unblock them:

```powershell
    Set-Location substitute-with-the-path-to-the-powershell_scripts-folder

    Unblock-File *.ps1
```

It should run after that.
