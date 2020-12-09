$xmas = Get-Content "$PSScriptRoot\\xmas.txt"

function Get-RangeSums($range)
{
    $sumCombinations = @()

    for($i = 0; $i -lt $range.Length; $i ++)
    {
        for($j = $i + 1; $j -lt $range.Length; $j ++)
        {
            $sumCombinations += [int]$range[$i] + [int]$range[$j]
            #"  {0} ({1}), {2} ({3}) == {4} --> {5}" -f $i, $range[$i], $j, $range[$j], ([int]$range[$i] + [int]$range[$j]), $sumCombinations.Count
        }
        
    }

    return $sumCombinations
}

$preamble = 25

for($i = 0; $i -lt ($xmas.Length - $preamble); $i ++)
{
    $startPosition = $i
    $endPosition = $i + $preamble - 1
    $currentPosition = $i + $preamble

    "running Get-RangeSums [{0}..{1}]" -f $startPosition, $endPosition
    $rangeSums = Get-RangeSums $xmas[$startPosition..$endPosition]
    #$rangeSums

    if($xmas[$currentPosition] -in $rangeSums)
    {
        #"{0} found in the result"-f $xmas[$currentPosition]
    }
    else
    {
        "{0} not found in the result <---------------------- STOP" -f $xmas[$currentPosition]
        break
    }
}
