$bags = Get-Content "$PSScriptRoot\\bags.txt"

function Get-Colours($line)
{
    $regex = '^(?<outerColour>.+) bags contain (?<innerColours>.+)\.$'
    $line -match $regex | Out-Null

    $outerColour = $Matches['outerColour']
    $innerColours = $Matches['innerColours']
    #"outer colour: {0}, inner colours: {1}" -f $outerColour, $innerColours

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
    $c = Get-Colours $_
    $colours[$c.outerColour] = $c.innerColours
}

function dig($path, $pv, $colourHash, $level = 1)
{
    $p0 = $path

    $colourHash.Keys | Where-Object {$_ -ne 'no other bags'} | ForEach-Object {
        
        $path = $p0 + ' (' + $pv + ') / ' + $_
        
        $a = dig $path ([int]$colourHash[$_] * [int]$pv) $colours[$_] ($level + 1)
        
        if($a)
        {
            "{0} [{1}] --> {2} * {3} == [{1}]" -f $path, ($pv * [int]$colourHash[$_]), $pv, [int]$colourHash[$_]
            $numbers[$path] = ($pv * [int]$colourHash[$_])
            $a
        }
        else
        {
            "{0} {1} --> {3} * {4} = [{2}]" -f $path, [int]$colourHash[$_], ($pv * [int]$colourHash[$_]), $pv, [int]$colourHash[$_]
            $numbers[$path] = ($pv * [int]$colourHash[$_])
        }
    }
}


$numbers = @{}
dig 'shiny gold' 1 $colours.'shiny gold'
'---------------------'
#$numbers
$numbers.Values | Measure-Object -Sum
"Number of bags: {0}" -f ($numbers.Values | Measure-Object -Sum).Sum

