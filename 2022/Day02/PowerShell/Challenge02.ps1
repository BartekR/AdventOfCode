# Rock = A
# Paper = B
# Scissors = C
# X - lose, Y - draw, Z - win

#$games = Get-Content '../Input0.txt'
$games = Get-Content '../Input.txt' #-First 10

$shapePoints = @{
    'A' = 1
    'B' = 2
    'C' = 3
}

$outcomes = @('X', 'Y', 'Z') # @(lose, draw, win)

$gameRules = @{
    #'elf' = @(lose, draw, win)
    'A' = @('C', 'A', 'B')
    'B' = @('A', 'B', 'C')
    'C' = @('B', 'C', 'A')
}

$total = 0

$games | ForEach-Object {
    $elf, $result = $_ -split ' '
    $outcomePosition = [array]::IndexOf($outcomes, $result)
    $myShape = $gameRules[$elf][$outcomePosition]
    $gamePts = 3 * $outcomePosition + $shapePoints[$myShape]
    $total += $gamePts
    "elf: {0}, outcome: {1}, I need: {2} -> {3}, gamePts: {4}, shapePts: {5}" -f $elf, $result, $outcomePosition, $myShape, $gamePts, $shapePoints[$myShape]
}

$total