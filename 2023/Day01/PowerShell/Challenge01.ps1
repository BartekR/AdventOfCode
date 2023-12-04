$calibrations = Get-Content "$PSScriptRoot\\..\\Input.txt" -Raw
$lines = $calibrations -split "`r`n"

$sum = 0

$lines | ForEach-Object {
    $_ -match '^([a-z]*)(?<first>\d)' | Out-Null
    $first = $Matches['first']
    ($_[-1..-$_.Length] -join '') -match '^([a-z]*)(?<last>\d)' | Out-Null # https://www.cloudnotes.io/revert-a-string-in-powershell/
    $last = $Matches['last']

    $sum += [int]$first * 10 + [int]$last
    
    "{0} - {1}{2} {3}" -f $_, $first, $last, $sum
}
