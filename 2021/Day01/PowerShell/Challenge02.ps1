$depths = Get-Content '../Input.txt'
# $depths.Count # 2000

$increased = 0
$notIncreased = 0

for($i = 0; $i -lt $depths.Count - 2; $i ++)
{
    $sumOfThisThree = [int]$depths[$i] + [int]$depths[$i+1] +[int]$depths[$i+2]
    $sumOfNextThree = [int]$depths[$i+1] + [int]$depths[$i+2] +[int]$depths[$i+3]
    if($sumOfNextThree -gt $sumOfThisThree)
    {
        $increased ++
    }
    else
    {
        $notIncreased ++
    }
}

$increased
$notIncreased