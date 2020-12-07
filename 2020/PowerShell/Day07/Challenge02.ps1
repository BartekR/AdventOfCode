$bags = Get-Content "$PSScriptRoot\\bags0.txt"

function Get-Colours($line)
{
    $regex = '^(?<outerColour>.+) bags contain (?<innerColours>.+)\.$'
    $line -match $regex | Out-Null

    $outerColour = $Matches['outerColour']
    $innerColours = $Matches['innerColours']
    "outer colour: {0}, inner colours: {1}" -f $outerColour, $innerColours

    $innerColoursHash = @{}
    $innerColours -split ', ' | ForEach-Object {
        
        $_ -match '(^(?<quantity>\d+) (?<colour>.+) (bag|bags)*$|(?<colour>no other bags))' | Out-Null
        ":: {0} - {1}" -f $Matches['colour'], $Matches['quantity']
        $innerColoursHash[$Matches['colour']] = $Matches['quantity']
    }

    return @{
        outerColour = $outerColour
        innerColours = $innerColoursHash
    }

}

$colours = @{}

$bags | ForEach-Object {
    #"--> {0}" -f $_
    $c = Get-Colours $_
    #$c
    $colours[$c.outerColour] = $c.innerColours
}

function dig($colourHash, $level = 1)
{
    $prefix = ('-' * $level)

    $colourHash.Keys | Where-Object {$_ -ne 'no other bags'} | ForEach-Object {
        "digging {0} {1} ({2})" -f $prefix, $_, [int]$colourHash[$_]
        dig $colours[$_] ($level + 1)
    }
}

function dig2($colourHash, $level = 1)
{
    if($null -ne $colourHash)
    {
        $prefix = ('-' * $level)

        $colourHash.Keys | ForEach-Object {
            "digging {0} {1} ({2})" -f $prefix, $_, [int]$colourHash[$_]
            $x0 = dig2 $colours[$_] ($level + 1)
            $x0
        }
    }
}

function dig3($colourHash, $level = 1)
{
    if($null -ne $colourHash)
    {
        $colourHash.Keys | ForEach-Object {
            dig3 $colours[$_] ($level + 1)
        }
        return [int]$colourHash[$_]
    }
}


#$colours.'shiny gold'
dig $colours.'shiny gold'
'---------------------'
dig2 $colours.'shiny gold'
'====================='
dig3 $colours.'shiny gold'
#$colours.'faded blue'

# $colours
# '---'
# $colours.'shiny gold'
