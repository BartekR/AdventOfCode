# Rock = A, X
# Paper = B, Y
# Scissors = C, Z
$games = Get-Content '../Input0.txt'

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

$games | ForEach-Object {
    $elf, $me = $_ -split ' '
    "elf: {0}, me: {1}, points: {2}" -f $elf, $me, $shapePoints[$me]
}