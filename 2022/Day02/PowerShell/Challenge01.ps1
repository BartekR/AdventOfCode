# Rock = A, X
# Paper = B, Y
# Scissors = C, Z
#$games = Get-Content '../Input0.txt'
$games = Get-Content '../Input.txt'

$shapePoints = @{
    'X' = 1
    'Y' = 2
    'Z' = 3
}

$gameRules = @{
    'A' = @('Z', 'X', 'Y')
    'B' = @('X', 'Y', 'Z')
    'C' = @('Y', 'Z', 'X')
}

$total = 0

$games | ForEach-Object {
    $elf, $me = $_ -split ' '
    $gamePts = 3 * [array]::IndexOf($gameRules[$elf], $me) + $shapePoints[$me]
    $total += $gamePts
    "elf: {0}, me: {1}, points: {2} + {3} = {4}" -f $elf, $me, $shapePoints[$me], (3 * [array]::IndexOf($gameRules[$elf], $me)), $gamePts
}

$total