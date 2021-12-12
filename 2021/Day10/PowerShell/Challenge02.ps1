$data = Get-Content "$PSScriptRoot\\..\\Input.txt"
#$data

$row = 0
$pointsForLines = [System.Collections.ArrayList]@()

$data | ForEach-Object {

    $stack = [System.Collections.ArrayList]@()

    for($i = 0; $i -lt $_.Length; $i ++)
    {
        $currentBracket = $_[$i]
    
        if($currentBracket -in ('[', '(', '{', '<'))
        {
            # an opening bracket, add to the stack
            $stack.Add($currentBracket) | Out-Null
        }
        else
        {
            # a closing bracket, verify whether it corresponds to the last opened bracket
            $lastOpenedBracket = $stack[$stack.Count - 1]
            $isValid = $false
    
            if(
                (($lastOpenedBracket -eq '[') -and ($currentBracket -eq ']')) `
                -or (($lastOpenedBracket -eq '{') -and ($currentBracket -eq '}')) `
                -or (($lastOpenedBracket -eq '(') -and ($currentBracket -eq ')')) `
                -or (($lastOpenedBracket -eq '<') -and ($currentBracket -eq '>'))
            )
            {
                $isValid = $true
            }

            # we want only the incomplete lines
            if($isValid)
            {
                #"remove | current open: {0} | closing bracket: {1} | isValid: {2} | stack: {3}" -f $lastOpenedBracket, $currentBracket, $isValid, ($stack -join '')
                $stack.RemoveAt($stack.Count - 1)
            }
            else
            {
                break
            }
        }
    }

    $row ++

    # we have a line to complete
    if($isValid)
    {
        $closingBrackets = [System.Collections.ArrayList]@()
        $points = 0

        for($i = $stack.Count; $i -ge 0; $i --)
        {
            switch ($stack[$i])
            {
                '[' { $closingBrackets.Add(']') | Out-Null ; $points = $points * 5 + 2}
                '{' { $closingBrackets.Add('}') | Out-Null ; $points = $points * 5 + 3}
                '(' { $closingBrackets.Add(')') | Out-Null ; $points = $points * 5 + 1}
                '<' { $closingBrackets.Add('>') | Out-Null ; $points = $points * 5 + 4}
            }
        }

        "row: {0} | currentLine: {1} | closingBrackets: {2} | points: {3}" -f $row, ($stack -join ''), ($closingBrackets -join ''), $points
        $pointsForLines.Add($points) | Out-Null
    }
}

$middlePoint = [Math]::Floor($pointsForLines.Count / 2)
$sortedPoints = $pointsForLines.GetEnumerator() | Sort-Object

"middlePoint: {0}" -f $sortedPoints[$middlePoint]