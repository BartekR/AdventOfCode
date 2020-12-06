$customDeclarations = Get-Content "$PSScriptRoot\\CustomDeclarations.txt" -Raw
#$customDeclarations = Get-Content "$PSScriptRoot\\c0.txt" -Raw
$cd = $customDeclarations -split "`r`n`r`n"

# example input:
# on
# aoqc
# owq
# coa
function answersCount($answers)
{
    $letters = @{}

    for($i = 0; $i -lt $answers.length; $i++)
    {
        $letters[$answers[$i]] += 1
    }

    # I need this foreach loop, as $letters[';'] does not work and I don't know why
    # I search for number of groups (number of separators (;)  + 1)
    $numberOfGroups = ($letters.Keys | Where-Object {$_ -eq ';'} | ForEach-Object {$letters[$_]}) + 1

    $res = ($letters.Keys | Where-Object {$letters[$_] -eq $numberOfGroups})

    # "groups: {0}, keys: {1}, value == groups: {2}" -f $numberOfGroups, $letters.Keys.Count, $res.Count
    # $letters

    return $res.Count
}

$sum = 0

$cd | ForEach-Object {

    $i = ($_ -replace ' ',';') -replace "`r`n", ';'

    $sum += answersCount $i

}

"Sum: {0}" -f $sum