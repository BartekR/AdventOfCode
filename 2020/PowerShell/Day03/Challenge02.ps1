function hitTheRoad($area, $right, $down, $print = 0) {
    $x = 1  # logical x position looking at the map, starting from 1
    $y = 1  # logical y position looking at the map, starting from 1

    $ax = $x - 1    # x position in array - COLUMN of the area, starting from 0
    $ay = $y - 1    # y position in array - ROW of the area, starting from 0

    $squares = 0
    $trees = 0

    $run = $true

    while ($run) {
        $x += $right
        $y += $down
    
        $ax += $right
        $ay += $down
    
        if($ax -ge $area[$ax].Length)
        {
            $ax = $ax - $area[$ax].Length
        }
    
        $position = $area[$ay][$ax]
    
        switch ($position)
        {
            '.' {$squares ++}
            '#' {$trees ++}
    
            default {}
        }
    
    
        if($y -ge $area.Length)
        {
            if($print -eq 1)
            {
                Write-Output "[$right, $down] squares: $squares, trees: $trees"
            }
            $run = $false
        }
        
    }

    return $trees
}

$area = Get-Content "$PSScriptRoot\\Area.txt"

# Right 1, down 1.
# Right 3, down 1.
# Right 5, down 1.
# Right 7, down 1.
# Right 1, down 2.

$h11 = hitTheRoad $area 1 1
$h31 = hitTheRoad $area 3 1
$h51 = hitTheRoad $area 5 1
$h71 = hitTheRoad $area 7 1
$h12 = hitTheRoad $area 1 2

"Result: {0}" -f ($h11 * $h31 * $h51 * $h71 * $h12)