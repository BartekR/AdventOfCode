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

        #"{0} {1} {2} .. {3} [{4}]" -f $i, $encodedPosition[$i -1], $lowerBound, $upperBound, ([Math]::Pow(2, 7 - $i))
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

        #"{0} {1} {2} .. {3} [{4}]" -f $i, $encodedPosition[$i + 7 -1], $lowerBound, $upperBound, ([Math]::Pow(2, 3 - $i))
    }
    
    $seat = $upperBound - 1

    return @{
        row = $row
        seat = $seat
    }
}

$highest = 0

$seats | ForEach-Object {
    $position = decodePosition $_
    $checksum = $position['row'] * 8 + $position['seat']

    if($checksum -gt $highest)
    {
        $highest = $checksum
    }
    "{0} {1} {2}" -f $position['row'], $position['seat'], $checksum
}

$highest