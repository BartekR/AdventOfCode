$navigations = Get-Content "$PSScriptRoot\\navigations.txt"

# we start facing east (E)
#$directions = 'ESWN'
$distances = @(0, 0, 0, 0)  # corresponding entries for distances in $directions

$waypoint = @(10, 0, 0, 1)  # starting at 10E, 1N

$navigations | ForEach-Object {

    $_ -match '^(?<command>[ESWNFRL])(?<value>\d+)' | Out-Null

    $command = $Matches['command']
    $value = $Matches['value']

    switch($command)
    {
        'F' {
            for($i = 0; $i -lt $distances.Count; $i ++)
            {
                $distances[$i] += $waypoint[$i] * $value
            }
        }
        'R' {
            $rotation = $value / 90         # 1 ..

            $tempWaypoint = @(0, 0, 0, 0)
            for($i = 0; $i -lt $waypoint.Count; $i ++)
            {
                if($i + $rotation -ge $waypoint.Count)
                {
                    $n = $i + $rotation - $waypoint.Count
                }
                else
                {
                    $n = $i + $rotation
                }
                $tempWaypoint[$n] = $waypoint[$i]
                #"processed: i = {0}, n = {1}, {2} -> {3}" -f $i, $n, $tempWaypoint[$i], $waypoint[$n]
            }
            #"waypoint ESWN ({0}) -> tempWaypoint ESWN: ({1})" -f ($waypoint -join ', '), ($tempWaypoint -join ', ')
            $waypoint = $tempWaypoint
        }
        'L' {
            $rotation = $value / 90         # 1 ..

            $tempWaypoint = @(0, 0, 0, 0)
            for($i = 0; $i -lt $waypoint.Count; $i ++)
            {
                if($i - $rotation -le $waypoint.Count * -1)
                {
                    $n = $i - $rotation + $waypoint.Count
                }
                else
                {
                    $n = $i - $rotation
                }
                $tempWaypoint[$n] = $waypoint[$i]
                #"processed: i = {0}, n = {1}, {2} -> {3}" -f $i, $n, $tempWaypoint[$i], $waypoint[$n]
            }
            #"waypoint ESWN ({0}) -> tempWaypoint ESWN: ({1})" -f ($waypoint -join ', '), ($tempWaypoint -join ', ')
            $waypoint = $tempWaypoint
        }
        'N' {$waypoint[3] += $value}
        'E' {$waypoint[0] += $value}
        'S' {$waypoint[1] += $value}
        'W' {$waypoint[2] += $value}
    }

    $waypointESWN = [string]$waypoint[0] + 'E, ' + [string]$waypoint[1] + 'S, ' + [string]$waypoint[2] + 'W, ' + [string]$waypoint[3] + 'N'
    "command: {1}, value: {2} --> waypoint: {0} ==> ESWN == {3}" -f $waypointESWN, $command, $value, ($distances -join ' : ')
}

$NS = [Math]::Abs($distances[3] - $distances[1])
$EW = [Math]::Abs($distances[0] - $distances[2])
"result: {0} + {1} == {2}" -f $NS, $EW, ($NS + $EW)