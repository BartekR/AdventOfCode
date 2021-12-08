$report = Get-Content "$PSScriptRoot\\..\\Input.txt"

# initialise an array with number of elements from the first row (all rows have the same number of elements)
$bits = @([int]0) * $report[0].Length
$gammaRate = $bits = @([int]0) * $report[0].Length
$epsilonRate = $bits = @([int]0) * $report[0].Length

$rows = 0

$report | ForEach-Object {
    for($i = 0; $i -lt $_.Length; $i++)
    {
        # https://stackoverflow.com/questions/61362035/numbers-change-inside-variables-for-powershell
        # $_[$i] returns char, not string, so casting char to int yields in ASCII value of code
        # hence instead of 0 I get 48 (ASCII value of 0)
        # casting to string first allows cast 0 to int as 0, not 48
        $bits[$i] += [int][string]$_[$i]
        #"_: {2}, i : {0}, _[i]: {1} :: {3}" -f $i, $_[$i], $_, $bits[$i]
    }
    $rows ++
}

for($i = 0; $i -lt $bits.Length; $i ++)
{
    if($rows - $bits[$i] -gt $bits[$i])
    {
        $gammaRate[$i] = 0
        $epsilonRate[$i] = 1
    }
    else
    {
        $gammaRate[$i] = 1
        $epsilonRate[$i] = 0
    }
}

$gammaInt = [Convert]::ToInt64($gammaRate -join '', 2)
$epsilonInt = [Convert]::ToInt64($epsilonRate -join '', 2)

"gammaRate = {0}, epsilonRate = {1}, powerConsumption = {2}" -f $gammaInt, $epsilonInt, ($gammaInt * $epsilonInt)