$depths = Get-Content '../Input.txt'
# $depths.Count # 2000

$increased = 0
$decreased = 0

for($i = 1; $i -lt $depths.Count; $i ++)
{
    if([int]$depths[$i] -gt [int]$depths[$i-1])
    {
        $increased ++
    }
    else
    {
        $decreased ++
    }

    #"Depth: {0}, Previous: {1} ==> increased: {2}, decreased: {3}" -f $depths[$i], $depths[$i-1], $increased, $decreased
}

$increased
$decreased