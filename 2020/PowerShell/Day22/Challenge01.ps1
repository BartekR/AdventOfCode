$decks = Get-Content "$PSScriptRoot\decks.txt" -Raw
$players = $decks -split "`r`n`r`n"

$p1 = $players[0] -split "`r`n"
$player1cards = $p1[1..($p1.Length - 1)]

$p2 = $players[1] -split "`r`n"
$player2cards = $p2[1..($p2.Length - 1)]

$p1cards = [System.Collections.ArrayList]$player1cards
$p2cards = [System.Collections.ArrayList]$player2cards

#"{0} vs {1}" -f ($player1cards -join ':'), ($player2cards -join ':')
"{0} vs {1}" -f ($p1cards -join ':'), ($p2cards -join ':')

$stop = $false
$round = 1

while($stop -eq $false)
{
    "round {0}, p1: [{1}], p2: [{2}] -> {3} vs {4}" -f $round, ($p1cards -join ':'), ($p2cards -join ':'), $p1cards[0], $p2cards[0]
    if([int]$p1cards[0] -gt [int]$p2cards[0])
    {
        $p1cards.Add($p1cards[0]) | Out-Null
        $p1cards.Add($p2cards[0]) | Out-Null
        $p1cards.RemoveAt(0)
        $p2cards.RemoveAt(0)
    }
    else
    {
        $p2cards.Add($p2cards[0]) | Out-Null
        $p2cards.Add($p1cards[0]) | Out-Null
        $p1cards.RemoveAt(0)
        $p2cards.RemoveAt(0)
    }

    if(($p1cards.Count -eq 0) -or ($p2cards.Count -eq 0))
    {
        $stop = $true
    }
    else
    {
        $round ++
    }
}

$winner = (($p1cards.Count -gt $p2cards.Count) ? $p1cards : $p2cards)
$winnerScore = 0

for($i = 0; $i -lt $winner.Count; $i++)
{
    $winnerScore += [int]$winner[$i] * ($winner.Count - $i)
}

"stop after {0} steps, winner's score: {1}" -f $round, $winnerScore
"p1: {0}" -f ($p1cards -join ':')
"p2: {0}" -f ($p2cards -join ':')
