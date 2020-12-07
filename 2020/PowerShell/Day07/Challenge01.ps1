# uses global variable to solve the challenge, I don't like it, but it works

$bags = Get-Content "$PSScriptRoot\\bags.txt"

function Get-Colours($line)
{
    $regex = '^(?<outerColour>.+) bags contain (?<innerColours>.+)\.$'
    $line -match $regex | Out-Null

    #"outer colour: {0}, inner colours: {1}" -f $Matches['outerColour'], $Matches['innerColours']

    return @{
        outerColour = $Matches['outerColour']
        innerColours = $Matches['innerColours']
    }
}

function findNumberOfGroups($colour, [hashtable]$allColours)
{
    $anchors = ($allColours.Keys | Where-Object {$allColours[$_].Contains($colour)})
    #$anchors
    
    if($anchors)
    {
        $anchors | ForEach-Object {
            $c1[$_] ++
            findNumberOfGroups $_ $allColours
        }
    }

}

$colours = @{}
$c1 = @{}

$bags | ForEach-Object {
    $c = Get-Colours $_

    $colours[$c['outerColour']] = $c['innerColours']
}

findNumberOfGroups 'shiny gold' $colours
$combinations = $c1.Count
#$c1

"Number of combinations: {0}" -f $combinations