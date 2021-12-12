$data = Get-Content "$PSScriptRoot\\..\\Input.txt"
#$data

$row = 0
$totalBonus = 0

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
    
            if($isValid)
            {
                #"remove | current open: {0} | closing bracket: {1} | isValid: {2} | stack: {3}" -f $lastOpenedBracket, $currentBracket, $isValid, ($stack -join '')
                $stack.RemoveAt($stack.Count - 1)
            }
            else
            {
                #"invalid {4} | current open: {0} | closing bracket: {1} | isValid: {2} | stack: {3}" -f $lastOpenedBracket, $currentBracket, $isValid, ($stack -join ''), $i
                
                switch($currentBracket)
                {
                    ')' { $bonus = 3 }
                    ']' { $bonus = 57 }
                    '}' { $bonus = 1197 }
                    '>' { $bonus = 25137 }
                }

                $totalBonus += $bonus

                "row: {0} | error at: {1} | bonus: {2} | totalBonus: {3}" -f ($row  +1), ($i + 1), $bonus, $totalBonus
                break
            }
        }
    }

    $row ++
}

