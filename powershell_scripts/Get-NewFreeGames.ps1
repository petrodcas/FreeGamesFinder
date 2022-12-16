$ErrorActionPreference = 'Stop' # stops the script's execution if any exception is thrown

$apiUrl = 'https://www.gamerpower.com/api/giveaways'
$prevExecutionOutputFile = 'prev_execution_results.csv'
$comparisonResultOutputFile = 'new_games.csv'
$onApiRequestFailMessage = "No internet connection or the API Service is down"
$onNoNewGamesMessage = 'No new free games found'
$onWaitingPressKeyMessage = "`nPress any key to exit."
$propertiesFilter = @('title', 'worth', 'platforms', 'type', 'open_giveaway', 'description', 'instructions', 'end_date')
$shownPropertiesName = @{
    $propertiesFilter[0] = 'Title'
    $propertiesFilter[1] = 'Worth'
    $propertiesFilter[2] = 'Platform'
    $propertiesFilter[3] = 'Type'
    $propertiesFilter[4] = 'Url'
    $propertiesFilter[5] = 'Description'
    $propertiesFilter[6] = 'Instructions'
    $propertiesFilter[7] = 'End date'
}
$scriptPath = $MyInvocation.MyCommand.Path | Split-Path -Parent
$outputFilesPath = $scriptPath
$noDataString = 'nodata'
$csvEncoding = 'unicode'
# Sample values: 'PC', 'DRM-Free', 'Steam', 'Android', 'PlayStation', 'Xbox', 'Gog', 'Itch.io', 'iOS'
$platformFilter = @() #@('pc', 'android')


function New-EmptyDataObject {
    $emptyResultObject = [PSCustomObject]@{}
    $propertiesFilter | ForEach-Object {
        $emptyResultObject | Add-Member -MemberType NoteProperty -Name "$_" -Value "$noDataString"
    }
    return $emptyResultObject 
}

function Test-IsArray {
    param ($o)
    $o -is [array]
}

function Test-MatchesAnyElement {
    param(
        [ValidateNotNullOrEmpty()][array]$array,
        [string]$str
    )

    [bool]$foundAnyMatch = $false

    [int]$indexCounter = 0
    while ( $indexCounter -le $array.length -and !$foundAnyMatch) {
        $foundAnyMatch = ($str -match $array[$indexCounter]) -or ($array[$indexCounter] -match $str)
        $indexCounter++
    }

    $foundAnyMatch
}

# Tries to get data from the api
try {
    $apiResults = Invoke-RestMethod $apiUrl
    $apiResults = $apiResults | Select-Object $propertiesFilter
} catch {
    Write-Host $onApiRequestFailMessage
    Exit 1
}

# Full path to the files relative to the script's location
$prevExecutionOutputFile = Join-Path $outputFilesPath $prevExecutionOutputFile
$comparisonResultOutputFile = Join-Path $outputFilesPath $comparisonResultOutputFile

# Makes sure that exists any previous data to compare to the current fetched one
if (!(Test-Path -Path $prevExecutionOutputFile -PathType Leaf)) {
    New-EmptyDataObject | Export-Csv $prevExecutionOutputFile -Encoding $csvEncoding -Force
}
# Imports the previous data
$prevResults = Import-Csv $prevExecutionOutputFile -Encoding $csvEncoding

# Compare the data to only output the difference. If exists any platform filter, then it is used to exclude the unneeded data.
if ($platformFilter) {
    
    $comparedResults = Compare-Object -ReferenceObject $prevResults -DifferenceObject $apiResults -Property $propertiesFilter `
    | Group-Object $propertiesFilter[0] | Where-Object { $_.Group[0].SideIndicator -ne '<=' -and (Test-MatchesAnyElement $_.Group[0].platforms $platformFilter) } `
    | ForEach-Object {
        $groupObject = $_.Group[0]
        $newObject = [PSCustomObject]@{}
        $propertiesFilter | ForEach-Object {
            $newObject | Add-Member -MemberType NoteProperty -Name $shownPropertiesName[$_] -Value $groupObject.$_
        }
        $newObject
    }

} else {

    $comparedResults = Compare-Object -ReferenceObject $prevResults -DifferenceObject $apiResults -Property $propertiesFilter `
    | Group-Object $propertiesFilter[0] | Where-Object { $_.Group[0].SideIndicator -ne '<=' } `
    | ForEach-Object {
        $groupObject = $_.Group[0]
        $newObject = [PSCustomObject]@{}
        $propertiesFilter | ForEach-Object {
            $newObject | Add-Member -MemberType NoteProperty -Name $shownPropertiesName[$_] -Value $groupObject.$_
        }
        $newObject
    }

}

# Saves the current fetched data to be used on the next execution
$apiResults | Export-Csv $prevExecutionOutputFile -Encoding $csvEncoding -Force

# If no new games are found, then saves an empty data file and prints a message notifying so, otherwise saves the results
if ($null -ne $comparedResults) {
    $comparedResults | Export-Csv -Encoding $csvEncoding $comparisonResultOutputFile -Force
    $comparedResults
} else {
    New-EmptyDataObject | Export-Csv -Encoding $csvEncoding $comparisonResultOutputFile -Force
    Write-Host $onNoNewGamesMessage
}

Write-Host $onWaitingPressKeyMessage
$HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | OUT-NULL
$HOST.UI.RawUI.Flushinputbuffer()