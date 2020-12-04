$passwordsList = Get-Content "$PSScriptRoot\\Passwords.txt"

$OK = 0
$nOK = 0

$passwordsList | ForEach-Object {
    $_ -match '(?<minLength>\d+)-(?<maxLength>\d+) (?<letter>[a-z]): (?<password>[a-z]+)' | Out-Null

    # how many times the letter apprears in the string?
    $h = $Matches['password'].Split($Matches['letter']).count - 1
    
    # also works
    # $h = [regex]::matches($Matches['password'], $Matches['letter']).count

    if($h -ge $Matches['minLength'] -and $h -le $Matches['maxLength'])
    {
        $OK ++
    }
    else
    {
        $nOK ++
    }

}

Write-Output "OK: $OK, nOK: $nOK"