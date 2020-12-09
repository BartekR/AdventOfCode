$xmas = Get-Content "$PSScriptRoot\\xmas.txt"

function Get-RangeSums($range)
{
    $sumCombinations = @()

    for($i = 0; $i -lt $range.Length; $i ++)
    {
        for($j = $i + 1; $j -lt $range.Length; $j ++)
        {
            $sumCombinations += [int]$range[$i] + [int]$range[$j]
        }
        
    }

    return $sumCombinations
}

function Find-WrongCombination($preamble, $xmas)
{
    for($i = 0; $i -lt ($xmas.Length - $preamble); $i ++)
    {
        $startPosition = $i
        $endPosition = $i + $preamble - 1
        $currentPosition = $i + $preamble

        $rangeSums = Get-RangeSums $xmas[$startPosition..$endPosition]

        if(-not ($xmas[$currentPosition] -in $rangeSums))
        {
            $wrongCombination = $xmas[$currentPosition]
            return $wrongCombination
        }
    }

    return -1
}

function Find-Streak($wrongCombination, $xmas)
{
    for($i = 0; $i -lt $xmas.Length; $i ++)
    {
        $chunkSum = 0
        $chunkNumbers = @()

        for($j = $i; $j -lt $xmas.Length; $j ++)
        {
            $chunkSum += [int]$xmas[$j]
            $chunkNumbers += [int]$xmas[$j]
            #"[{0}][{1}] currentSum == {2}" -f $i, $j, $chunkSum

            if($chunkSum -gt $wrongCombination)
            {
                #"too much -> {0}" -f $chunkSum
                break
            }
            if($chunkSum -eq $wrongCombination)
            {
                $res = ($chunkNumbers | Measure-Object -Minimum -Maximum)
                #"perfect! -> [{1} .. {2}] == {0} --> {3} + {4} == {5}" -f $chunkSum, $i, $j, $res.Minimum, $res.Maximum, ($res.Minimum + $res.Maximum)
                return ($res.Minimum + $res.Maximum)
            }
        }
    }
}

$preamble = 25

$wrongCombination = Find-WrongCombination $preamble $xmas
#$wrongCombination

$streak = Find-Streak $wrongCombination $xmas
$streak
