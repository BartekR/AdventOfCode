# attempt with all combinations using bitmap mask
# but without converting to the full length (no PadLeft)
# additional constraints: starting with minimum bolts ($minLength)
# still slow - 1.2M iterations/minute

$jolts = Get-Content "$PSScriptRoot\\jolts1.txt"

$sortedJolts = ($jolts | Sort-Object { [int]$_ })
$maxJolt = [int]($sortedJolts[-1])
$minLength = [int]($maxJolt / 3)

"sorted jolts (count: {0}, max: {1}): {2}" -f $sortedJolts.Count, $maxJolt, ($sortedJolts -join ',')
"minLength: {0}" -f $minLength

$goodCombinations = 0
$goodSolutions = @()

function Test-Adapters($adapters)
{
    for($j = 1; $j -lt $adapters.Count; $j ++)
    {
        #"{0} -> {1} - {2} == {3}" -f $j, $adapters[$j], $adapters[$j - 1], ($adapters[$j] - $adapters[$j - 1])
        if($adapters[$j] - $adapters[$j - 1] -gt 3)
        {
            return $false
        }
    }
    
    return $true
}

# based on https://stackoverflow.com/questions/27690918/array-find-and-indexof-for-multiple-elements-that-are-exactly-the-same-object
function Get-IndicesOf($length, $Array, $Value)
{
    $i = $length - $Array.Length
    foreach ($el in $Array)
    { 
        if ($el -eq $Value) { $i } # $i == 1-based, $i - 1 == 0-based
        ++$i
    }
}

$tests = 0

$d1 = Get-Date
$d1.ToString('yyyy-MM-dd HH:mm:ss')
#for($i = 64; $i -le 80; $i ++)
for($i = ([Math]::Pow(2, $minLength) - 1); $i -lt [Math]::Pow(2, $jolts.Count); $i ++)
#for($i = 1; $i -lt [Math]::Pow(2, $jolts.Count); $i ++)
{
    $n = [System.Convert]::ToString($i, 2)                          # convert number to binary format
    $k = Get-IndicesOf $sortedJolts.Count ($n.ToCharArray()) '1'    # find, where are 1's located  ...
    $jolts1 = @('0') + @($sortedJolts[$k]) + @($maxJolt + 3)        # ... and get only these positions from the jolts (plus the sockets)
    
    # no use of testing if we have no last adapter ($n ends with 1)
    if($n.EndsWith('1') -and $n.Length -ge $minLength)
    {
        $goodCombinations += Test-Adapters $jolts1
        $tests ++
    }
    
    #"{2} :: {3} >> {0} | {1}  | {4} / {5}" -f ($k -join ';'), ($jolts1 -join ':'), $i, ($sortedJolts -join ','), $goodCombinations, $tests

    if($i % 100000 -eq 0)
    {
        $d2 = Get-Date
        $dt = New-TimeSpan -Start $d1 -End $d2
        "[{0}:{1}] {2} iterations completed; found combinations: {3} in {4} tests" -f $dt.Minutes, $dt.Seconds, $i, $goodCombinations, $tests
    }
}

"found: {0} in {1} iterations ({2} tests)" -f $goodCombinations, $i, $tests
$goodSolutions