$navigations = Get-Content "$PSScriptRoot\\navigations.txt"

# we start facing east (E)
$directions = 'ESWN'
$distances = @(0, 0, 0, 0)  # corresponding entries for distances in $directions

$currentDirection = 0   # $directions[0] == E

$navigations | ForEach-Object {

    $_ -match '^(?<command>[ESWNFRL])(?<value>\d+)' | Out-Null

    $command = $Matches['command']
    $value = $Matches['value']
    $currentDirectionNSWE = $directions[$currentDirection]

    switch($command)
    {
        'F' {
            $distances[$currentDirection] += $value
        }
        'R' {
            $rotation = $value / 90         # 1 ..
            $currentDirection += $rotation  # moving RIGHT of ESWN
            if($currentDirection -ge $directions.Length)
            {
                $currentDirection -= $directions.Length
            }
        }
        'L' {
            $rotation = $value / 90         # 1 ..
            $currentDirection -= $rotation  # moving LEFT of ESWN
            if($currentDirection -le ($directions.Length * -1))
            {
                $currentDirection += $directions.Length
            }
        }
        'N' {$distances[3] += $value}
        'E' {$distances[0] += $value}
        'S' {$distances[1] += $value}
        'W' {$distances[2] += $value}
    }

    "Current direction: {0}, command: {1}, value: {2}  ==> ESWN == {3}" -f $currentDirectionNSWE, $command, $value, ($distances -join ' : ')
}

$NS = [Math]::Abs($distances[3] - $distances[1])
$EW = [Math]::Abs($distances[0] - $distances[2])
"result: {0} + {1} == {2}" -f $NS, $EW, ($NS + $EW)