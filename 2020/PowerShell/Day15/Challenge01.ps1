$startingNumbers = '0,14,1,3,7,9'

#$startingNumbers = '0,3,6' #2020th number == 436

# $startingNumbers = '1,3,2' #2020th number == 1
# $startingNumbers = '2,1,3' #2020th number == 10
# $startingNumbers = '1,2,3' #2020th number == 27
# $startingNumbers = '2,3,1' #2020th number == 78
# $startingNumbers = '3,2,1' #2020th number == 438
# $startingNumbers = '3,1,2' #2020th number == 1836

$counters = @{}
$turn = 0
$lastNumber = 0

function Set-Counts([int]$val, $turn)
{
    if($null -eq $counters.Item([string]$val))
    {
        $counters.Item([string]$val) = @{
            lastspokenInTurn = $turn
            howManyTimesUntilNow = 1
            previouslySpokenInTurn = $turn
        }
    }
    else
    {
        $counter = $counters.Item([string]$val)
        $previousTurn = $counter.lastspokenInTurn

        $counter.lastspokenInTurn = $turn
        $counter.howManyTimesUntilNow ++
        $counter.previouslySpokenInTurn = $previousTurn
    }

    #"T{0} added: {1}" -f $turn, $val
}

$startingNumbers -split ',' | ForEach-Object {
    $turn ++

    Set-Counts $_ $turn

    $lastNumber = $_
}


for($i = $turn + 1; $i -le 2020; $i ++)
{
    $lastCounter = $counters.Item([string]$lastNumber)  # in hashtables I have to pass a string as the key, not number!!

    if(($lastCounter).howManyTimesUntilNow -eq 1)
    {
        ">T{0}, previous value: {1}, seen times: {2}, last seen: T{3} ({4}), previously seen: T{5}, so result is: 0" -f $i, $lastNumber, $lastCounter.howManyTimesUntilNow, $lastCounter.lastspokenInTurn, ($i - 1), $lastCounter.previouslySpokenInTurn
        $lastNumber = 0

        Set-Counts 0 $i
    }
    else
    {
        $nextNumber = [int]($lastCounter.lastspokenInTurn) - [int]($lastCounter.previouslySpokenInTurn)
        ">>T{0}, previous value: {1}, seen times: {2}, last seen: T{3} ({4}), previously seen: T{5}, so result is: {6} ({7})" -f $i, $lastNumber, $lastCounter.howManyTimesUntilNow, $lastCounter.lastspokenInTurn, ($i - 1), $lastCounter.previouslySpokenInTurn, $nextNumber, ([int]$lastCounter.lastspokenInTurn - [int]$lastCounter.previouslySpokenInTurn)
        Set-Counts $nextNumber $i

        $lastNumber = $nextNumber
    }

}
