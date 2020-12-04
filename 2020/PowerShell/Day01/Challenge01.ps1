$numbersList = Get-Content -Path '.\Numbers.txt'
#$numbers = 10
$numbers = $numbersList.Count
$results = @()

# for($i = 0; $i -le $numbers.Count; $i ++)
# {
#     for($j = $i + 1; $j -le $numbers.Count; $j ++)
#     {
#         $sum = $numbers[$i] + $numbers[$j]
#         "$i :: $j :: $sum"
#     }
# }

for($i = 0; $i -lt $numbers; $i ++)
{
    for($j = $i + 1; $j -le $numbers; $j ++)
    {
        $sum = [int]$numbersList[$i] + [int]$numbersList[$j]
        #"$i :: $j :: $sum"
        if($sum -eq 2020)
        {
            $mlt = [int]$numbersList[$i] * [int]$numbersList[$j]
            $results += @($i, $j, $sum, $mlt)
        }
    }
}

$results