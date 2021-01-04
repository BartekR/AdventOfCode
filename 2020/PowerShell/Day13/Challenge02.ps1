# no pattern, just calculations using lcm (least common multiple)

$departure = Get-Content "$PSScriptRoot\departure.txt"
$departures = $departure[1] -split ','

#$departures = '2,3,5' -split ','
#$departures = '2,3,5,x,9' -split ','
#$departures = '17,13' -split ','
#$departures = '17,x,13' -split ','
#$departures = '17,x,13,19' -split ','
#$departures = '67,7,59,61' -split ','
#$departures = '67,7,x,59,61' -split ','
#$departures = '7,13,x,x,59,x,31,19' -split ','
#$departures = '1789,37,47,1889' -split ','

# $buses is an ArrayList of bus numbers and departure offsets, like (17, 0), (13, 2), (19, 3)
$buses = [System.Collections.ArrayList]@()

for($j = 0; $j -lt $departures.Length; $j ++)
{
    if($departures[$j] -ne 'x')
    {
        $buses.Add(@($departures[$j], $j)) | Out-Null
    }
}

$iterations = 0
$lcm = 1

$timestamp = [int]$departures[0]
#$timestamp = 0

for($d = 0; $d -lt $buses.Count - 1 ; $d ++)
{
    $bus_id = $buses[$d + 1][0]
    $idx = $buses[$d + 1][1]
    $lcm *= $buses[$d][0]

    while(($timestamp + $idx) % $bus_id -ne 0)
    {
        $timestamp += $lcm
        $iterations ++
    }
}

"timestamp {0} found in {1} iterations" -f $timestamp, $iterations
