$calories = Get-Content "$PSScriptRoot\\..\\Input.txt" -Raw
$caloriesLinesPerElf = $calories -split "`r`n`r`n"

$caloriesPerElf = [System.Collections.ArrayList]@()

# $caloriesLinesPerElf is a (multiple line) string; change it to array splitting by newLine
$caloriesLinesPerElf | ForEach-Object {
    $c = ($_ -split "`r`n" | Measure-Object -Sum | Select-Object Sum)
    $caloriesPerElf.Add($c.Sum) | Out-Null
}

$caloriesPerElf | Sort-Object -Descending -Top 3 | Measure-Object -Sum | Select-Object Sum