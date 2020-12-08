function Read-Code($path)
{
    $code = Get-Content $path
    $instructions = @()

    $regex = '^(?<instruction>[a-z]{3}) (?<value>.+)$'
    
    $code | ForEach-Object {
        $_ -match $regex | Out-Null

        #"{0} - {1} ({2})" -f $Matches['instruction'], $Matches['value'], [int]$Matches['value']

        $instructions += [PSCustomObject]@{instruction = $Matches['instruction']; value = [int]$Matches['value']}

    }

    return $instructions
}

$acc = 0
$visited = @()
$iterations = 0

$a = Read-Code "$PSScriptRoot\\bootcode.txt"

for($i = 0; $i -lt $a.Count; $i ++)
{
    $iterations ++

    if(-not ($visited -contains $i))
    {
        $visited += $i
        $command = $a[$i]

        $current = $i
        $jump = 1 # go to next

        switch($command.instruction)
        {
            'acc' {$acc += $command.value}
            'nop' {}
            'jmp' {$i += $command.value - 1; $jump = $command.value}
        }

        "[{0}] {1}: {2} {3} --> {4} :: go to {5}" -f $iterations, $current, $command.instruction, $command.value, $acc, ($i + 1)
    }
    else
    {
        "[{3}] ---------------> STOP (jumped {0} to already visited position {1}) --> acc == {2}" -f $jump, $i, $acc, $iterations
        exit
    }

    
}
