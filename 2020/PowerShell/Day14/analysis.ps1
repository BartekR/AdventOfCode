$program = Get-Content "$PSScriptRoot\\program.txt"
$addresses = @()

$mask = $mem = 0
$program | ForEach-Object {
    if($_.StartsWith("mask"))
    {
        $mask ++
    }
    else
    {
        $mem++
        $_ -match 'mem\[(\d+)\].+' | Out-Null
        if(($Matches[1] -in $addresses) -eq $false)
        {
            $addresses += $Matches[1]
        }
    }
}

$mask   # 100
$mem    # 471
$addresses.Count    # 404

# max value: 68719476735 (2^36 -1)