$passports = Get-Content "$PSScriptRoot\\Passports.txt" -Raw
$p0 = $passports -split "`r`n`r`n"

# byr (Birth Year)
# iyr (Issue Year)
# eyr (Expiration Year)
# hgt (Height)
# hcl (Hair Color)
# ecl (Eye Color)
# pid (Passport ID)
# cid (Country ID)

#$passportFields = @('byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid', 'cid')
$requiredFields = @('byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid')

#$p0[0]

$valid = 0
$all = 0

$p0 | ForEach-Object {
    $i = ($_ -replace ' ',';') -replace "`r`n", ';'
    #$i

    $passportFields = @()
    $i -split ';' | ForEach-Object {
        $_ -match '(?<field>[a-z]{3}):(?<value>.+)' | Out-Null
        
        if($Matches['field'] -ne 'cid')
        {
            $passportFields += $Matches['field']
        }
        
    }
    if((Compare-Object -ReferenceObject $requiredFields -DifferenceObject $passportFields).Count -eq 0)
    {
        $valid ++
    }
    $all ++
}

"Valid: {0} of {1}" -f $valid, $all