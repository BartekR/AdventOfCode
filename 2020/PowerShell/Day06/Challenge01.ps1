$customDeclarations = Get-Content "$PSScriptRoot\\CustomDeclarations.txt" -Raw
$cd = $customDeclarations -split "`r`n`r`n"

# example input:
# on
# aoqc
# owq
# coa
function distinctCount($answers)
{
    $lettersCount = @{}

    for($i = 0; $i -lt $answers.length; $i++)
    {
        $lettersCount[$answers[$i]] += 1
    }

    return ($lettersCount.Keys).Count
}

$sum = 0

$cd | ForEach-Object {

    $i = ($_ -replace ' ','') -replace "`r`n", ''

    $sum += (distinctCount $i)

}

"Sum: {0}" -f $sum