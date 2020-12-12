$seats = Get-Content "$PSScriptRoot\\seats.txt"

$rows = $seats.Length
$columns = $seats[0].Length

# to avoid testing if array position exists outside of the bounds add the floor (.) around the seats
$seats1 = @('.' * $columns) + $seats + @('.' * $columns)

for($i = 0; $i -le $rows + 1; $i ++)
{
    $seats1[$i] = '.' + $seats1[$i] + '.'
}

"rows (y): {0}, columns (x): {1}" -f $rows, $columns

$seatPlan = @() + $seats1
$iterations = 0

$a = $true

while($a -eq $true)
{
    $newSeatPlan = @('.' * ($columns + 2))
    $iterations ++

    #"iteration {0} ----------------- START" -f $iterations

    # 1 .. $value - I analyse $seats1 using values from $seats
    for($y = 1; $y -le $rows; $y ++)
    {
        $currentRow = ''

        for($x = 1; $x -le $columns; $x ++)
        {
            $occupied = 0

            # N
            $nY = $y - 1; $nX = $x
            while($nY -ge 0 -and ($seatPlan[$nY][$nX] -eq '.')) { $nY -- }
            if($seatPlan[$nY][$nX] -eq '#') {$occupied ++}

            # NE
            $nY = $y - 1; $nX = $x + 1
            while(($nY -ge 0) -and ($nX -le $columns) -and ($seatPlan[$nY][$nX] -eq '.')) { $nY --; $nX ++ }
            if($seatPlan[$nY][$nX] -eq '#') {$occupied ++}

            # E
            $nY = $y; $nX = $x + 1
            while($nX -le $columns -and ($seatPlan[$nY][$nX] -eq '.')) { $nX ++}
            if($seatPlan[$nY][$nX] -eq '#') {$occupied ++}

            # SE
            $nY = $y + 1; $nX = $x + 1
            while(($nY -le $rows) -and ($nX -le $columns) -and ($seatPlan[$nY][$nX] -eq '.')) { $nY ++; $nX ++ }
            if($seatPlan[$nY][$nX] -eq '#') {$occupied ++}

            # S
            $nY = $y + 1; $nX = $x
            while(($nY -le $rows) -and ($seatPlan[$nY][$nX] -eq '.')) { $nY ++ }
            if($seatPlan[$nY][$nX] -eq '#') {$occupied ++}

            # SW
            $nY = $y + 1; $nX = $x - 1
            while(($nY -le $rows) -and ($nX -ge 0) -and ($seatPlan[$nY][$nX] -eq '.')) { $nY ++; $nX -- }
            if($seatPlan[$nY][$nX] -eq '#') {$occupied ++}

            # W
            $nY = $y; $nX = $x - 1
            while(($nX -ge 0) -and ($seatPlan[$nY][$nX] -eq '.')) { $nX -- }
            if($seatPlan[$nY][$nX] -eq '#') {$occupied ++}

            # NW
            $nY = $y - 1; $nX = $x - 1
            while(($nY -ge 0) -and ($nX -ge 0) -and ($seatPlan[$nY][$nX] -eq '.')) { $nY --; $nX -- }
            if($seatPlan[$nY][$nX] -eq '#') {$occupied ++}

            #"occupied: {0}, seatplan[{1}][{2}] = {3}" -f $occupied, $y, $x, $seatPlan[$y][$x]
            if(($seatPlan[$y][$x] -eq 'L') -and ($occupied -eq 0))
            {
                $currentRow += '#'
            }
            elseif(($seatPlan[$y][$x] -eq '#') -and ($occupied -ge 5))
            {
                $currentRow += 'L'
            }
            else
            {
                $currentRow += $seatPlan[$y][$x]
            }

        }

        $currentRow = '.' + $currentRow + '.'

        $newSeatPlan += , $currentRow

    }

    $newSeatPlan += , ('.' * ($columns + 2))

    $nP = ($newSeatPlan | Foreach-Object {$_ -join ''}) -join ''
    $cP = ($seatPlan | Foreach-Object {$_ -join ''}) -join ''

    $a = ($nP -ne $cP)
    if($a)
    {
        # $seatPlan
        # '-' * 12
        # $newSeatPlan
        $seatPlan = $newSeatPlan
    }
    #"iteration {0} [$a] ----------------- END" -f $iterations
}

# $seatPlan
# '-' * 12
# $newSeatPlan

$allOccupied = 0
$seatPlan | ForEach-Object {
    for($i = 0; $i -lt $_.Length; $i ++)
    {
        if($_[$i] -eq '#') {$allOccupied ++}
    }
}

"iterations: {0}, Occupied: {1}" -f $iterations, $allOccupied