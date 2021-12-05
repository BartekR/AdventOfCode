$directions = Get-Content "$PSScriptRoot\\..\\Input.txt"

$positions = @{}

$directions | ForEach-Object {
    $_ -match '(?<x1>\d+),(?<y1>\d+) -> (?<x2>\d+),(?<y2>\d+)' | Out-Null

    if($Matches['x1'] -eq $Matches['x2'])
    {
        $start = [int]$Matches['y1']
        $stop = [int]$Matches['y2']
        
        if($start -gt $stop)
        {
            $start = [int]$Matches['y2']
            $stop = [int]$Matches['y1']
        }
        
        for($i = $start; $i -le $stop; $i++)
        {
            $key = $Matches['x1'] + '_' + $i
            $positions[$key] ++
        }

        "[x] ({0}, {1}) -> ({2}, {3}) | {4} .. {5}" -f $Matches['x1'], $Matches['y1'], $Matches['x2'], $Matches['y2'], $start, $stop
    }
    elseif($Matches['y1'] -eq $Matches['y2'])
    {
        $start = [int]$Matches['x1']
        $stop = [int]$Matches['x2']
        
        if($start -gt $stop)
        {
            $start = [int]$Matches['x2']
            $stop = [int]$Matches['x1']
        }
        
        for($i = $start; $i -le $stop; $i++)
        {
            $key = [string]$i + '_' + $Matches['y1']
            $positions[$key] ++
        }

        "[y] ({0}, {1}) -> ({2}, {3}) | {4} .. {5}" -f $Matches['x1'], $Matches['y1'], $Matches['x2'], $Matches['y2'], $start, $stop
    }
    else
    {
        $startX = [int]$Matches['x1']
        $stopX = [int]$Matches['x2']
        
        $startY = [int]$Matches['y1']
        $stopY = [int]$Matches['y2']

        if($startX -lt $stopX)
        {
            $moveY = 0
            for($i = $startX; $i -le $stopX; $i ++)
            {
                $key = [string]$i + '_' + ($startY + $moveY)
                $positions[$key] ++

                if($startY -lt $stopY)
                {
                    $moveY ++
                }
                else
                {
                    $moveY --
                }
                #$key
            }
        }

        if($startX -gt $stopX)
        {
            $moveY = 0
            for($i = $startX; $i -ge $stopX; $i --)
            {
                $key = [string]$i + '_' + ($startY + $moveY)
                $positions[$key] ++

                if($startY -lt $stopY)
                {
                    $moveY ++
                }
                else
                {
                    $moveY --
                }
                #$key
            }
        }
        
        "[d] ({0}, {1}) -> ({2}, {3}) | {4} .. {5}, {6} .. {7}" -f $Matches['x1'], $Matches['y1'], $Matches['x2'], $Matches['y2'], $startX, $stopX, $startY, $stopY
    }
}

# https://devblogs.microsoft.com/scripting/weekend-scripter-sorting-powershell-hash-tables/
# $positions.GetEnumerator() | Sort-Object -Property Name

($positions.Values | Where-Object {$_ -ge 2} | Measure-Object).Count