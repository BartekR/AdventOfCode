# works, but slow - 1.2M iterations/minute
# inefficient as it analyses all possible permutations

$jolts = Get-Content "$PSScriptRoot\\jolts1.txt"

$sortedJolts = ($jolts | Sort-Object { [int]$_ })
$maxJolt = [int]$sortedJolts[-1]

"sorted jolts (count: {0}, max: {1}): {2}" -f $sortedJolts.Count, $maxJolt, ($sortedJolts -join ',')

$goodCombinations = 0
$goodSolutions = @()

function Test-Adapters($adapters)
{
    for($j = 1; $j -lt $adapters.Count; $j ++)
    {
        #"{0} -> {1} - {2} == {3}" -f $j, $adapters[$j], $adapters[$j - 1], ($adapters[$j] - $adapters[$j - 1])
        if($adapters[$j] - $adapters[$j - 1] -gt 3)
        {
            #"exiting loop at j = {0} ----> STOP" -f $j
            return $false
        }
    }
    
    return $true
}

# https://stackoverflow.com/questions/27690918/array-find-and-indexof-for-multiple-elements-that-are-exactly-the-same-object
function Get-IndicesOf($Array, $Value)
{
    $i = 0
    foreach ($el in $Array)
    { 
        if ($el -eq $Value) { $i } # $i == 1-based, $i - 1 == 0-based
        ++$i
    }
}

$d1 = Get-Date
$d1.ToString('yyyy-MM-dd HH:mm:ss')

# All combinations: 2^($jolts.Count) - n-element bitmask
#for($i = 1; $i -le 5; $i ++)
for($i = 1; $i -lt [Math]::Pow(2, $jolts.Count); $i ++)
{
    $n = [System.Convert]::ToString($i, 2)                          # convert number to binary format
    $a = $n.PadLeft($jolts.Count - 1, '0')                          # add leading zeroes (to have the full overview)
    $k = Get-IndicesOf ($a.ToCharArray()) '1'                       # find, where are 1's located  ...
    $jolts1 = @('0') + @($sortedJolts[$k]) + @($maxJolt + 3)   # ... and get only these positions from the jolts (plus the sockets)
    #"{3} :: {4} >> {0} -> {1} | {2}" -f $a, ($k -join ';'), ($jolts1 -join ':'), $i, ($sortedJolts -join ',')

    # no use of testing if we have no last adapter ($n ends with 1)
    if($n.EndsWith('1'))
    {
        $goodCombinations += Test-Adapters $jolts1
    }

    if($i % 100000 -eq 0)
    #if($i % 1000 -eq 0)
    {
        $d2 = Get-Date
        $dt = New-TimeSpan -Start $d1 -End $d2
        "[{0}:{1}] {2} iterations completed" -f $dt.Minutes, $dt.Seconds, $i
    }
}

"found: {0} in {1} iterations" -f $goodCombinations, $i
$goodSolutions