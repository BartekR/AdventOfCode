$data = Get-Content "$PSScriptRoot\\..\\Input.txt"

$positions = $data -split ','

$info = ($positions | Measure-Object -Maximum -Minimum)
$info.Minimum
$info.Maximum

$maxValue = $info.Maximum * $positions.Length
$position = -1

for($i = $info.Minimum; $i -le $info.Maximum; $i++)
{
    $fuel = 0
    
    #"all go to {0}" -f $i

    for($j = 0; $j -lt $positions.Length; $j++)
    {
        $fuel += [Math]::abs($i - $positions[$j])
        #"position: {2} -> {4}, fuel to move: {3}, total fuel: {0}, j: {1}" -f $fuel, $j, $positions[$j], ([Math]::abs($i - $positions[$j])), $i
    }

    "all go to {0} == {1} fuel" -f $i, $fuel

    if($fuel -lt $maxValue)
    {
        $maxValue = $fuel
        $position = $i
    }
}

"cheapest possible outcome: go to {0} using {1} fuel" -f $position, $maxValue