$bingo = Get-Content "$PSScriptRoot\\..\\Input.txt" -Raw
$b0 = $bingo -split "`r`n`r`n"

$bingoNumbers = $b0[0]

# bingo boards are the remaining $b0 elements - $b0[1..n]
# each board is stored as a string containing five `r`n elements, I need it in rows and columns format

$bingoBoards = [System.Collections.ArrayList]@()
$bingoTrackers = [System.Collections.ArrayList]@()
$bingoBoardsSums = [System.Collections.ArrayList]@()
$bingoFlags = @(0) * ($b0.Length - 1)

# prepare bingo boards
for($i = 1; $i -lt $b0.Length; $i ++)
{
    $board = $b0[$i].Replace(' ', ',').Replace("`r`n", ',').Replace(',,', ',') + ','
    if($board[0] -ne ',')
    {
        $board = ',' + $board
    }
    #$board
    $bingoBoards.Add($board) | Out-Null
    $bingoTrackers.Add(@(0) * 10) | Out-Null        # tracking 5 rows + 5 columns for bingo (diagonals don't count)
    $bingoBoardsSums.Add((($board -split ',' | Measure-Object -Sum).Sum)) | Out-Null    # initial sum of all (unmarked) elements
}

'+++++++++++++++'

($bingoNumbers -split ',') | ForEach-Object {
    $number = $_

    for($i = 0; $i -lt $bingoBoards.Count; $i++)
    {
        # do not analyse the board if it already is a winning one
        if($bingoFlags[$i] -eq 1)
        {
            continue
        }

        # bingo board as an array
        $board = $bingoBoards[$i].Substring(1, $bingoBoards[$i].Length - 2) -split ','

        # in element not found .IndexOf() returns -1, then ignore the board and go to the next one
        if($board.IndexOf($number) -eq -1)
        {
            continue
        }

        # for display purposes only - put number in square brackets
        $bingoBoards[$i] = $bingoBoards[$i].Replace(",$number,", ",[$number],")
        
        # some explanatory values
        $numberPositionInBoard = $board.IndexOf($number) + 1    # 1-based, 1..25
        $boardRow = [Math]::Ceiling(($board.IndexOf($number) + 1) / 5) # 1-based, 1..5
        $boardColumn = ($numberPositionInBoard % 5 -eq 0 ? 5 : $numberPositionInBoard % 5) # 1-based 1..5
        $trackerRow = $boardRow - 1
        $trackerColumn = $boardColumn + 5 - 1

        # track whether row or column hits five values
        $bingoTrackers[$i][$trackerRow] += 1
        $bingoTrackers[$i][$trackerColumn] += 1

        if(($bingoTrackers[$i][$trackerRow] -eq 5) -or ($bingoTrackers[$i][$trackerColumn] -eq 5))
        {
            $bingoFlags[$i] = 1
        }

        # update the sum of unmarked values
        $prev = $bingoBoardsSums[$i]
        $bingoBoardsSums[$i] -= $number


        "{0} | {1} | r = {2}, c = {3} | {4} | {5} | {6} => {7} | {8}" -f `
            $number.PadLeft(2, ' '), `
            $numberPositionInBoard.ToString().PadLeft(2, ' '), `
            $boardRow, `
            $boardColumn, `
            $bingoBoards[$i].Substring(1, $bingoBoards[$i].Length - 2).PadRight(100, ' '), `
            ($bingoTrackers[$i] -join '.'), `
            $prev, `
            $bingoBoardsSums[$i], `
            $bingoFlags[$i]

        if(($bingoFlags | Measure-Object -Sum).Sum -eq $b0.Length - 1)
        {
            "Result: unmarkedSum: {0}, number: {1}, multiplied: {2}" -f $bingoBoardsSums[$i], $number, ($bingoBoardsSums[$i] * $number)
            exit
        }
    }


}
'==='