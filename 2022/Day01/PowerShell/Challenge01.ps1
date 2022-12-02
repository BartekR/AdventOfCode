$calories = Get-Content "$PSScriptRoot\\..\\Input.txt" -Raw
$caloriesLinesPerElf = $calories -split "`r`n`r`n"

$maxCalories = 0

# $caloriesLinesPerElf is a (multiple line) string; change it to array splitting by newLine
$caloriesLinesPerElf | ForEach-Object {
    $c = ($_ -split "`r`n" | Measure-Object -Sum | Select-Object Sum)
    if($c.Sum -gt $maxCalories)
    {
        $maxCalories = $c.Sum
    }
}

$maxCalories