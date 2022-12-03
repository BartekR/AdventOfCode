#$rucksacks = Get-Content "$PSScriptRoot\\..\\Input0.txt"
$rucksacks = Get-Content "$PSScriptRoot\\..\\Input.txt"

# priorities a..z  1..26 ascii: 97..122
# priorities A..Z 27..52 ascii: 65..90

$prioritiesSum = 0

for($i = 0; $i -lt $rucksacks.Length; $i++)
{
    "rows: {0}, {1}, {2}" -f $rucksacks[$i], $rucksacks[$i + 1], $rucksacks[$i + 2]
    
    foreach($c in $rucksacks[$i].ToCharArray()) {
        if($rucksacks[$i + 1].ToCharArray().Contains($c))
        {
            if($rucksacks[$i + 2].ToCharArray().Contains($c))
            {
                $priority = [byte][char]$c -gt 90 ? [byte][char]$c - 97 + 1 : [byte][char]$c - 65 + 27
                "char: {0} ascii: {1} priority: {2}" -f $c, [byte][char]$c, $priority
                $prioritiesSum += $priority
                break
            }
        }
    }
    $i += 2
}

$prioritiesSum