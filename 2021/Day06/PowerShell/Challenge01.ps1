$lanterns = Get-Content "$PSScriptRoot\\..\\Input0.txt"

$startSeries = [System.Collections.ArrayList]@()
$lanterns -split ',' | ForEach-Object {
    $startSeries.Add($_) | Out-Null
}

"0 values: {1}" -f $i, ($startSeries -join ',')

for($i = 1; $i -le 18; $i ++)
{
    # I store the number of elements in the ArrayList, because if I will use it in for(;;) it will calculate the number of elements with each iteration
    $lastValue = $startSeries.Count

    for($j = 0; $j -lt $lastValue; $j ++)
    {
        if($startSeries[$j] -eq 0)
        {
            $startSeries[$j] = 6
            $startSeries.Add(8) | Out-Null
        }
        else
        {
            $startSeries[$j] -= 1
        }
    }

    "{0} values: {1}, all: {2}" -f $i, ($startSeries -join ','), $startSeries.Count
    #"{0} all: {1}" -f $i, $startSeries.Count
}

