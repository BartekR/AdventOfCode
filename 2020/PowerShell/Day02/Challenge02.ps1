$passwordsList = Get-Content "$PSScriptRoot\\Passwords.txt"

$OK = 0
$nOK = 0

$passwordsList | ForEach-Object {
    $_ -match '(?<pos1>\d+)-(?<pos2>\d+) (?<letter>[a-z]): (?<password>[a-z]+)' | Out-Null

    # it will be easier to read if I use a variables without brackets
    $password = $Matches['password']
    $pos1 = $Matches['pos1']
    $pos2 = $Matches['pos2']
    $letter = $Matches['letter']

    #"$password $letter $pos1 $pos2"

    if(
            ($password[$pos1 - 1] -eq $letter -and $password[$pos2 - 1] -eq $letter) `
        -or ($password[$pos1 - 1] -ne $letter -and $password[$pos2 - 1] -ne $letter)
    )
    {
        $nOK ++
    }
    else
    {
        $OK ++
    }

}

Write-Output "OK: $OK, nOK: $nOK"