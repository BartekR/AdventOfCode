Import-Module PSWriteColor

$area = Get-Content "$PSScriptRoot\\Area.txt"
# $area.length # 323
# $area[0].length # 31
$x = 1  # logical x position looking at the map, starting from 1
$y = 1  # logical y position looking at the map, starting from 1

$ax = $x - 1    # x position in array - COLUMN of the area, starting from 0
$ay = $y - 1    # y position in array - ROW of the area, starting from 0

$squares = 0
$trees = 0

$position = $area[$ay][$ax]
$tx = ('00' + $x).SubString(('00' + $x).length - 3, 3)
$ty = ('00' + $y).SubString(('00' + $y).Length - 3, 3)

Write-Color -Text "row $ty, column $tx = $position --> ", ($area[$ay][$ax] -join ''), ($area[$ay][($ax + 1) .. ($area[$ax].Length - 1)] -join '') `
            -Color White, Blue, White

while ($true) {
    $x += 3
    $y += 1

    $ax += 3
    $ay += 1
    $ax0 += 3  # tracking the original $ax

    if($ax -ge $area[$ax].Length)
    {
        $ax = $ax - $area[$ax].Length
    }

    $position = $area[$ay][$ax]

    $tx = ('00' + $x).SubString(('00' + $x).length - 3, 3)
    $ty = ('00' + $y).SubString(('00' + $y).Length - 3, 3)

    if($ax -lt $area[$ax].Length - 1)
    {
        $sufix = $area[$ay][($ax + 1) .. ($area[$ax].Length - 1)] -join ''
    }
    else
    {
        $sufix = ''
    }

    if($ax -le 0)
    {
        $prefix = ''
    }
    else
    {
        $prefix = $area[$ay][0..($ax - 1)] -join ''
    }

    switch ($position)
    {
        '.' {$squares ++}
        '#' {$trees ++}

        default {}
    }

    Write-Color -Text "row $ty, column $tx = $position --> ", `
                    $prefix, `
                    ($area[$ay][$ax]), `
                    $sufix, `
                    "  trees: $trees, squares: $squares" `
                -Color White, White, Blue, White, Green

    if($y -ge $area.Length)
    {
        Write-Output "squares: $squares, trees: $trees"
        return $false
    }
    
}