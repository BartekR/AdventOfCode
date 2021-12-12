$data = Get-Content "$PSScriptRoot\\..\\Input.txt"

$lowPoints = 0
$riskLevel = 0

for($row = 0; $row -lt $data.Length; $row ++)
{
    $prev = if($row -gt 0) { $data[$row - 1] } else { '.' * $data[$row].Length }
    $next = if($row -lt $data.Length -1) { $data[$row + 1] } else { '.' * $data[$row].Length }

    '---------------------------------------------------'
    "--> {0}" -f $prev
    "==> {0}" -f $data[$row]
    "++> {0}" -f $next
    for($column = 0; $column -lt $data[$row].Length; $column ++)
    {
        $current = $data[$row][$column]
        $left = if($column -gt 0) {$data[$row][$column - 1]} else { 10 }
        $right = if($column -lt $data[$row].Length - 1) { $data[$row][$column + 1] } else { 10 }
        $top = if($row -gt 0) { $data[$row - 1][$column] } else { 10 }
        $bottom = if($row -lt $data.Length - 1) { $data[$row + 1][$column] } else { 10 }

        #"$left > $current and $right > $current and $top > $current and $bottom > $current"

        # as in Day03 - to get int, frst cast to string (as I get char and it converts to ASCII code)
        #"{0} > {1} and {2} > {0} and {3} > {1} and {4} > {1}" -f [int][string]$left, [int][string]$current, [int][string]$right, [int][string]$top, [int][string]$bottom
        if([int][string]$left -gt [int][string]$current -and [int][string]$right -gt [int][string]$current -and [int][string]$top -gt [int][string]$current -and [int][string]$bottom -gt [int][string]$current)
        {
            $lowPoints ++
            $riskLevel += [int][string]$current + 1
            "[!] $left > $current and $right > $current and $top > $current and $bottom > $current | $current ==> $lowPoints | $riskLevel"
        }

        #"[{0}, {1}] adjacent for {2}: left: {3} | right: {4} | top: {5} | bottom: {6} | {7}" -f $row, $column, $current, $left, $right, $top, $bottom, $lowPoints
    }
}

$lowPoints
$riskLevel