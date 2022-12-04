#$areas = Get-Content "$PSScriptRoot\\..\\Input0.txt"
$areas = Get-Content "$PSScriptRoot\\..\\Input.txt"

$allScopes = 0

$areas | ForEach-Object {
    $pair1, $pair2 = $_ -split ','
    [int]$pair1low, [int]$pair1high = $pair1 -split '-'
    [int]$pair2low, [int]$pair2high = $pair2 -split '-'

    $inScope = 0

    if(($pair1high -ge $pair2low) -and ($pair1low -le $pair2high))
    {
        $inScope = 1
        $allScopes ++
    }

    "p1: {0}, p2: {1}, i: {2}, a: {3}" -f $pair1, $pair2, $inScope, $allScopes
}

$allScopes