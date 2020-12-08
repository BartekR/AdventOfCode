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

$bootcodes = Read-Code "$PSScriptRoot\\bootcode.txt"

$jmp = @()
$nop = @()

for($i = 0; $i -lt $bootcodes.Count; $i ++)
{
    $command = $bootcodes[$i]

    switch($command.instruction)
    {
        'nop' {$nop += $i}
        'jmp' {$jmp += $i}
    }
}

"testing nop -> jmp"
for($n = 0; $n -lt $nop.Count; $n ++)
{
    $acc = 0
    $visited = @()
    $iterations = 0
    $err = $false

    $a = $bootcodes   # setting a copy of the array

    $nopPosition = $nop[$n]

    $c0 = $a[$nopPosition].instruction 
    $a[$nopPosition].instruction = 'jmp'
    $c1 = $a[$nopPosition].instruction 

    "[$n] changed {0} to {1} at {2}" -f $c0, $c1, $nopPosition

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

            "  [{0}] {1}: {2} {3} --> {4} :: go to {5}" -f $iterations, $current, $command.instruction, $command.value, $acc, ($i + 1)
        }
        else
        {
            "  [{3}] ---------------> STOP (jumped {0} to already visited position {1}) --> acc == {2}" -f $jump, $i, $acc, $iterations
            $err = $true
            break
        }
    }

    if($err -eq $false)
    {
        "Found solution. acc == {0}" -f $acc
        exit
    }

    
    $c0 = $a[$nopPosition].instruction 
    $a[$nopPosition].instruction = 'nop'
    $c1 = $a[$nopPosition].instruction 

    "[$n] changed {0} to {1} at {2}" -f $c0, $c1, $jmpPosition
}

"testing jmp -> nop"

# testing jmp -> nop
for($n = 0; $n -lt $jmp.Count; $n ++)
{
    $acc = 0
    $visited = @()
    $iterations = 0
    $err = $false

    $a = $bootcodes   # setting a copy of the array

    $jmpPosition = $jmp[$n]

    $c0 = $a[$jmpPosition].instruction 
    $a[$jmpPosition].instruction = 'nop'
    $c1 = $a[$jmpPosition].instruction 

    "[$n] changed {0} to {1} at {2}" -f $c0, $c1, $jmpPosition

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

            "  [{0}] {1}: {2} {3} --> {4} :: go to {5}" -f $iterations, $current, $command.instruction, $command.value, $acc, ($i + 1)
        }
        else
        {
            "  [{3}] ---------------> STOP (jumped {0} to already visited position {1}) --> acc == {2}" -f $jump, $i, $acc, $iterations
            $err = $true
            break
        }
    }

    if($err -eq $false)
    {
        "Found solution. acc == {0}" -f $acc
        exit
    }

    
    $c0 = $a[$jmpPosition].instruction 
    $a[$jmpPosition].instruction = 'jmp'
    $c1 = $a[$jmpPosition].instruction 

    "[$n] changed {0} to {1} at {2}" -f $c0, $c1, $jmpPosition
}

"err: $err"
