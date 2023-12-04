$calibrations = Get-Content "$PSScriptRoot\\..\\Input.txt" -Raw
$lines = $calibrations -split "`r`n"

$sum = 0

$lines | ForEach-Object {
    $_ -match '^(\w*?)(?<first>one|two|three|four|five|six|seven|eight|nine|\d)' | Out-Null
    $first = $Matches['first']

    # brute force for reverse - reverse the pattern, and reverse the found value
    ($_[-1..-$_.Length] -join '') -match '(\w*?)(?<last>eno|owt|eerht|ruof|evif|xis|neves|thgie|enin|\d)' | Out-Null # https://www.cloudnotes.io/revert-a-string-in-powershell/
    $last = $Matches['last'][-1..-$Matches['last'].Length] -join ''

    # map strings to numbers
    $map = @{
        'one' = 1
        'two' = 2
        'three' = 3
        'four' = 4
        'five' = 5
        'six' = 6
        'seven' = 7
        'eight' = 8
        'nine' = 9
    }

    $sum += [int]$($map[$first] ?? $first) * 10 + [int]$($map[$last] ?? $last) # https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.4#null-coalescing-operator-
    
    "{0} - {1}|{2} {3} | {4} {5}" -f $_, $first, $last, $sum, ($map[$first] ?? $first), ($map[$last] ?? $last)
}
