$navigation = Get-Content "$PSScriptRoot\\..\\Input.txt"

$forward = 0
$depth = 0
$aim = 0

$navigation | ForEach-Object {
    $direction, $quantity = $_.split(' ')
    
    switch($direction)
    {
        'forward'   { 
                        $forward += $quantity
                        $depth += $aim * $quantity
                    }
        'up'        { $aim -= $quantity }
        'down'      { $aim += $quantity }
    }
}

"forward: {0}, depth: {1} ==> forward * depth == {2}" -f $forward, $depth, ($forward * $depth)