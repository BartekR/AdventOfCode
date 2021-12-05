$navigation = Get-Content "$PSScriptRoot\\..\\Input.txt"

$forward = 0
$depth = 0

$navigation | ForEach-Object {
    $direction, $quantity = $_.split(' ')
    
    switch($direction)
    {
        'forward'   { $forward += $quantity }
        'up'        { $depth -= $quantity }
        'down'      { $depth += $quantity }
    }
}

"forward: {0}, depth: {1} ==> forward * depth == {2}" -f $forward, $depth, ($forward * $depth)