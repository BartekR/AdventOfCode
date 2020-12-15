# $startingNumbers = '0,14,1,3,7,9'

$startingNumbers = '0,3,6' #2020th number == 436

# $startingNumbers = '1,3,2' #2020th number == 1
# $startingNumbers = '2,1,3' #2020th number == 10
# $startingNumbers = '1,2,3' #2020th number == 27
# $startingNumbers = '2,3,1' #2020th number == 78
# $startingNumbers = '3,2,1' #2020th number == 438
# $startingNumbers = '3,1,2' #2020th number == 1836

$counters = @{}
$turn = 0
$lastNumber = 0

$numbers = $startingNumbers -split ',' | ForEach-Object {
    if($null -eq $counters.$_)
    {
        $turn ++
        $counters.$_ = @{lastspoken = $turn}
        $lastNumber = $_
    }
}

for($i = $turn; $i -le 2020; $i ++)
{
    if($lastNumber)
}

$counters.Values.lastspoken