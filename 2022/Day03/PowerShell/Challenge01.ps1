#$rucksacks = Get-Content "$PSScriptRoot\\..\\Input0.txt"
$rucksacks = Get-Content "$PSScriptRoot\\..\\Input.txt"

# priorities a..z  1..26 ascii: 97..122
# priorities A..Z 27..52 ascii: 65..90

$prioritiesSum = 0

$rucksacks | ForEach-Object {
    "row: {0}" -f $_
    $allElements = $_.Length
    $elementsInEachCompartment = $allElements / 2

    $firstCompartment = $_[0..($elementsInEachCompartment - 1)]
    $secondCompartment = $_[$elementsInEachCompartment..($allElements - 1)]

    foreach($c in $firstCompartment) {
        if($secondCompartment.Contains($c))
        {
            $priority = [byte][char]$c -gt 90 ? [byte][char]$c - 97 + 1 : [byte][char]$c - 65 + 27
            "char: {0} ascii: {1} priority: {2}" -f $c, [byte][char]$c, $priority
            $prioritiesSum += $priority
            break
        }
    }
}

$prioritiesSum