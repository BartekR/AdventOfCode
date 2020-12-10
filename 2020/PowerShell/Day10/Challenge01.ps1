$jolts = Get-Content "$PSScriptRoot\\jolts.txt"

# sort by number: https://stackoverflow.com/questions/15040460/sort-object-and-integers
# also: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/sort-object?view=powershell-7.1#example-8--sort-a-string-as-an-integer
$sortedJolts = ($jolts | Sort-Object { [int]$_ })

# $jolts
# '---'
# $sortedJolts

# we start with 0, so starting $ones = 1
# we end up with additional possible 3 jolts, so $threes = 1

$ones = 1
$threes = 1
$others = 0

for($i = 1; $i -lt $sortedJolts.Count; $i ++)
{
    #"{0} -> {1} - {2} == {3}" -f $i, $sortedJolts[$i], $sortedJolts[$i - 1], ($sortedJolts[$i] - $sortedJolts[$i - 1])
    switch($sortedJolts[$i] - $sortedJolts[$i - 1])
    {
        3 {$threes ++}
        1 {$ones ++}

        default {$others ++}
    }
}

"{0}, {1} ({2}) ==> {3}" -f $threes, $ones, $others, ($threes * $ones)