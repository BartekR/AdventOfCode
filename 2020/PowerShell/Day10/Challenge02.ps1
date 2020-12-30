# solution based on answers by: ACProctor (in Ruby), digtydoo (Python), jsut_ (perl)
# https://www.reddit.com/r/adventofcode/comments/ka8z8x/2020_day_10_solutions/gfd237l/?utm_source=reddit&utm_medium=web2x&context=3
# https://www.reddit.com/r/adventofcode/comments/ka8z8x/2020_day_10_solutions/gfcxuxf/?utm_source=reddit&utm_medium=web2x&context=3
# https://www.reddit.com/r/adventofcode/comments/ka8z8x/2020_day_10_solutions/gfcaqju/?utm_source=reddit&utm_medium=web2x&context=3

$jolts = Get-Content "$PSScriptRoot\\jolts.txt"

$sortedJolts = ($jolts | Sort-Object { [int]$_ })
$maxJolt = [int]($sortedJolts[-1])
$sortedJolts0 = $sortedJolts + ($maxJolt + 3)  # no initial socket, implemented in solution #3
$sortedJolts = @(0) + $sortedJolts + ($maxJolt + 3)

"sorted jolts (count: {0}, max: {1}): {2}" -f $sortedJolts.Count, $maxJolt, ($sortedJolts -join ',')

# analysing the series of the jolts; for informational purposes - how long are the 1-jolt-difference streaks?
function Get-ConsecutiveCounts($adapters)
{
    $consecutives = @()
    $serie = 1
    for($j = 1; $j -lt $adapters.Count; $j ++)
    {
        if($adapters[$j] - $adapters[$j - 1] -eq 1)
        {
            $serie ++
        }
        else
        {
            $consecutives += $serie
            $serie = 1
        }
    }

    return $consecutives
}

# ACProctor's solution
function Get-Combinations1($adapters, $permutations)
{
    $total = 1
    $serie = 1
    for($j = 1; $j -lt $adapters.Count; $j ++)
    {
        if($adapters[$j] - $adapters[$j - 1] -eq 1)
        {
            $serie ++
        }
        else
        {
            $total *= $permutations[$serie]
            $serie = 1
        }
    }

    return $total
}

# digtydoo's solution
function Get-Combinations2($adapters)
{
    # prepare a table filled with 0's (and 1 for the [0] index) for every possible jolt
    $paths = , 0 * ([int]($adapters[-1]) + 3)
    $paths[0] = 1

    for($j = 0; $j -lt $adapters.Count; $j ++)
    {
        $adapter = [int]$adapters[$j]

        for($diff = 1; $diff -le 3; $diff ++)
        {
            $nextAdapter = $adapter + $diff
            if($nextAdapter -in $adapters)
            {
                $paths[$nextAdapter] += $paths[$adapter]
            }
        }
    }

    $paths
}

# jsut_ "oh, it’s just the sum of the ways you can get to the three before" https://www.reddit.com/r/adventofcode/comments/ka8z8x/2020_day_10_solutions/gfcu0iw/?utm_source=reddit&utm_medium=web2x&context=3
function Get-Combinations3($adapters)
{
    $paths = @{0 = 1}
    "adapter: 0: 1"
    foreach($adapter in $adapters)
    {
        # splitting to $p1, $p2, $p3 so it';'s easier to see the changes in the debugger
        $p1 = ($null -eq $paths[[int]$adapter - 1] ? 0 : $paths[[int]$adapter - 1])
        $p2 = ($null -eq $paths[[int]$adapter - 2] ? 0 : $paths[[int]$adapter - 2])
        $p3 = ($null -eq $paths[[int]$adapter - 3] ? 0 : $paths[[int]$adapter - 3])
        
        $paths[[int]$adapter] = $p1 + $p2 + $p3

        "adapter: {0}: {1}" -f $adapter, $paths[[int]$adapter]
    }
}

# permutations were calculated by hand. See README.md for details, added 0 element to have a more readable code
$permutations = @(0, 1, 1, 2, 4, 7)

$combinations = Get-Combinations1 $sortedJolts $permutations

"Get-Combinations  :: found: {0}" -f $combinations

$c2 = Get-Combinations2 $sortedJolts
#$c2

"Get-Combinations2 :: found: {0}" -f $c2[$maxJolt]

'---'
Get-Combinations3 $sortedJolts0