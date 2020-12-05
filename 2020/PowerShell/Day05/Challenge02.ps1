$seats = Get-Content "$PSScriptRoot\\Seats.txt"

# example input: BFBFFBFRLR
function decodePosition($encodedPosition)
{
    # first 7 letters: row, positions 0..127
    $lowerBound = 1
    $upperBound = 128
    
    for($i = 1; $i -le 7; $i ++)
    {
        switch($encodedPosition[$i - 1])
        {
            'B' {
                $lowerBound = $lowerBound + ([Math]::Pow(2, 7 - $i))
            }
            'F' {
                $upperBound = $upperBound - ([Math]::Pow(2, 7 - $i))
            }
        }
    }

    $row = $upperBound - 1

    # last 3 letters: seat
    $lowerBound = 1
    $upperBound = 8
    
    for($i = 1; $i -le 3; $i ++)
    {
        switch($encodedPosition[$i + 7 - 1])
        {
            'R' {
                $lowerBound = $lowerBound + ([Math]::Pow(2, 3 - $i))
            }
            'L' {
                $upperBound = $upperBound - ([Math]::Pow(2, 3 - $i))
            }
        }
    }
    
    $seat = $upperBound - 1

    return @{
        row = $row
        seat = $seat
    }
}

$allSeats = @{}
$minRow = 127
$maxRow = 0

$seats | ForEach-Object {
    $position = decodePosition $_

    $minRow = ($position['row'] -lt $minRow ? $position['row'] : $minRow)
    $maxRow = ($position['row'] -gt $maxRow ? $position['row'] : $maxRow)

    $allSeats[$position['row']] += @($position['seat'])
}

# find a row, where not all places are occuppied excluding the first and the last row
$allSeats.Keys | Where-Object {
    ($allSeats[$_].count -lt 8) -and ($_ -ne $minRow) -and ($_ -ne $maxRow)
} | ForEach-Object {
    ($allSeats[$_] | Compare-Object -ReferenceObject @(0..7)).InputObject
}

#$mySeat

$myRow = ($allSeats.Keys | Where-Object {
    ($allSeats[$_].count -lt 8) -and ($_ -ne $minRow) -and ($_ -ne $maxRow)
})
$mySeat = ($allSeats[$myRow] | Compare-Object -ReferenceObject @(0..7)).InputObject

$seatId = $myRow * 8 + $mySeat

"{0} ({1}, {2})" -f $seatId, $myRow, $mySeat

# 522