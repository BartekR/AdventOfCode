$program = Get-Content "$PSScriptRoot\\program.txt"

$mask = $value = 0
$addresses = @{}

$program | ForEach-Object {
    if($_.StartsWith("mask"))
    {
        $mask = $_.Substring(7, $_.Length - 7)
        $mask
    }
    else
    {
        $_ -match 'mem\[(\d+)\] = (\d+)' | Out-Null

        $address = $Matches[1]
        $value = $Matches[2]
        $binValue = [Convert]::ToString($value, 2)
        $longBinValue = (('0' * $mask.Length) + $binValue).Substring($binValue.Length, $mask.Length)

        $result = ''
        for($i = 0; $i -lt $mask.Length; $i ++)
        {
            switch($mask[$i])
            {
                'X' {$result += $longBinValue[$i]}
                
                default {$result+= $mask[$i]}
            }
        }

        "{3} | {0} - {1} [{2}]" -f $address, $value, $binValue, $longBinValue
        "{0} == {1}" -f $result, [Convert]::ToInt64($result, 2)

        $addresses[$address] = @{'value' = [Convert]::ToInt64($result, 2); 'longBinValue' = $result}
    }
}

$sum = 0
$addresses | ForEach-Object {
    $sum += ($_).value
    ##$_.values.value
}

$sum

$addresses.Values.value | Measure-Object -Sum