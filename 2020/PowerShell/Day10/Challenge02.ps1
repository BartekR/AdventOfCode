$jolts = Get-Content "$PSScriptRoot\\jolts0.txt"

$sortedJolts = ($jolts | Sort-Object { [int]$_ })

$ones = 1
$twos = 0
$threes = 1
$others = 0

# remove 1 adapter
for($i = 0; $i -lt $sortedJolts.Count; $i ++)
{
    if($i -eq 0)
    {
        $workArray = $sortedJolts[1..($sortedJolts.Count - 1)]
    }
    else
    {
        $workArray = $sortedJolts[0..$i] + $sortedJolts[($i + 2)..($sortedJolts.Count - 1)]
    }
    
    $workArray -join ','

    "i = {0}, array[i] = {1}, array[i-1] = {2} array[i] - array[i-1] == {3}" -f $i, $workArray[$i], $workArray[$i - 1], ($workArray[$i] - $workArray[$i - 1])
    switch($workArray[$i] - $workArray[$i - 1])
    {
        3 {$threes ++}
        2 {$twos ++}
        1 {$ones ++}

        default {$others ++}
    }
}

"{0}, {1}, {2} | {3}" -f $threes, $twos, $ones, $others