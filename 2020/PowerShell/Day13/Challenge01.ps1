$departure = Get-Content "$PSScriptRoot\\departure.txt"

$timestamp = $departure[0]
$buses = $departure[1] -split ',' | Where-Object {$_ -ne 'x'}

$maxWaitTime = ($buses | Measure-Object -Maximum).Maximum
$takeBusNr = $maxWaitTime

$buses | ForEach-Object {
    $res = $timestamp / [int]$_
    $next = [Math]::Ceiling($res) * [int]$_
    $waitTime = $next - $timestamp
    if($waitTime -lt $maxWaitTime)
    {
        $takeBusNr = $_
        $maxWaitTime = $waitTime
    }
    #"{0} / {1} == {2} --> {3} * {1} == {4} | {5} / {6}" -f $timestamp, $_, $res, [Math]::Ceiling($res), $next, $waitTime, $maxWaitTime
}

"Wait {0} minutes for the bus nr {1} ({2})" -f $maxWaitTime, $takeBusNr, ($maxWaitTime * $takeBusNr)