$numbersList = Get-Content -Path '.\Numbers.txt'
#$numbers = 10
$numbers = $numbersList.Count
$results = @()

for($i = 0; $i -lt $numbers; $i ++)
{
    for($j = $i + 1; $j -lt $numbers; $j ++)
    {
        for($k = $j + 1; $k -lt $numbers; $k ++)
        {
            $sum = [int]$numbersList[$i] + [int]$numbersList[$j] + [int]$numbersList[$k]
            #"$i :: $j :: $sum"
            if($sum -eq 2020)
            {
                $mlt = [int]$numbersList[$i] * [int]$numbersList[$j] * + [int]$numbersList[$k]
                $results += [PSCustomObject]@{
                    i = $i
                    j = $j
                    k = $k
                    in = [int]$numbersList[$i]
                    ij = [int]$numbersList[$j]
                    ik = [int]$numbersList[$k]
                    sum = $sum
                    mlt = $mlt
                }
            }
        }
        
    }
}

$results