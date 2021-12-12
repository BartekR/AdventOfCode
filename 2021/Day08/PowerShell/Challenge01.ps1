$data = Get-Content "$PSScriptRoot\\..\\Input.txt"

$knownDigits = 0

$data | ForEach-Object {
    # to split by pipe, I must escape it
    $digits = ($_ -split ' \| ')[1]
    $knownDigits += ($digits -split ' ' | Where-Object {$_.Length -in (2, 3, 4, 7)}).Count

    "{0} | total knownDigits found: {1}" -f (($digits -split ' ' | Where-Object {$_.Length -in (2, 3, 4, 7)}) -join ' :: ').PadRight(40, ' '), $knownDigits
}

$knownDigits