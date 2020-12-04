$passports = Get-Content "$PSScriptRoot\\Passports.txt" -Raw
$p0 = $passports -split "`r`n`r`n"

function isValid($field, $value)
{
    switch($field)
    {
        'byr' {return ([int]$value -ge 1920) -and ([int]$value -le 2002) ? $true : $false}
        'iyr' {return ([int]$value -ge 2010) -and ([int]$value -le 2020) ? $true : $false}
        'eyr' {return ([int]$value -ge 2020) -and ([int]$value -le 2030) ? $true : $false}
        'hgt' {
            $value -match '(?<height>\d+)(?<unit>in|cm)$' | Out-Null
            if($Matches)
            {
                switch($Matches['unit'])
                {
                    'in' {return (([int]$Matches['height'] -ge 59) -and ([int]$Matches['height'] -le 76)) ? $true : $false}
                    'cm' {return (([int]$Matches['height'] -ge 150) -and ([int]$Matches['height'] -le 193)) ? $true : $false}
                }
            }
            else
            {
                return $false
            }
        }
        'hcl' {return ($value -match '#[0-9a-f]{6}')}
        'ecl' {return ($value -in @('amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'))}
        'pid' {return ($value -match '^\d{9}$')}

    }
}

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

$valid = 0
$all = 0

$p0 | ForEach-Object {
    $i = ($_ -replace ' ',';') -replace "`r`n", ';'

    $passportFields = @()
    $passportValid = $true

    $i -split ';' | ForEach-Object {

        $_ -match '(?<field>[a-z]{3}):(?<value>.+)' | Out-Null
        
        if($Matches['field'] -ne 'cid')
        {
            $passportFields += $Matches['field']
            $iv = isValid $Matches['field'] $Matches['value']
            $passportValid = ($passportValid -and $iv)

            "({0}, {1}) -> {2} / {3}" -f $Matches['field'], $Matches['value'], $iv, $passportValid
        }
    }

    if(
        ((Compare-Object -ReferenceObject $requiredFields -DifferenceObject $passportFields).Count -eq 0) `
        -and ($passportValid)
    )
    {
        $valid ++
    }
    $all ++
    "----------------------------- $valid"
}

"Valid: {0} of {1}" -f $valid, $all