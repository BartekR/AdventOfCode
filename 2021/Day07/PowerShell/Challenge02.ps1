$data = Get-Content "$PSScriptRoot\\..\\Input.txt"

$positions = $data -split ','

$info = ($positions | Measure-Object -Maximum -Minimum)
$info.Minimum
$info.Maximum

$maxValue = $info.Maximum * (((1 + $info.Maximum) / 2 ) * ($info.Maximum - $info.Minimum - 1))
$position = -1

for($i = $info.Minimum; $i -le $info.Maximum; $i++)
{
    $fuel = 0
    
    #"all go to {0}" -f $i

    for($j = 0; $j -lt $positions.Length; $j++)
    {
        # using arithmetic progression
        $a1 = 1
        $an = [Math]::abs($i - [int]$positions[$j])
        $n = [Math]::abs($i - [int]$positions[$j])
        $s = (($a1 + $an) / 2 ) * $n

        $fuel += $s
        # "position: {2} -> {4}, fuel to move: {3}, total fuel: {0}, j: {1} | a1: {5}, an: {6}, n = {7}" -f `
        #     $fuel, $j, $positions[$j], $s, $i, `
        #     $a1, $an, $n
    }

    "all go to {0} == {1} fuel" -f $i, $fuel
    #'----------------'

    if($fuel -lt $maxValue)
    {
        $maxValue = $fuel
        $position = $i
    }

    "current: fuel: {0}, max: {1}, pos: {2}" -f $fuel, $maxValue, $position
}

"cheapest possible outcome: go to {0} using {1} fuel" -f $position, $maxValue