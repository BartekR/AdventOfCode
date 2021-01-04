# Second challenge solution

My approaches to the second challenge involved:

* brute-force checing all combinatons and testing masks - does not scale at all
* tracking cycles - when each number has a full cycle - does not scale and is not faster than brute-force (still iterated all combinations)
* working only on nunmbers (converting X to 0, still analysing masks) - a bit faster, but still slow
* realising that I don't need to check all timestamps - I can jump the first bus timestamp each time (as I have to start from the first bus) - fast as hell, but not enough to solve the problem

I was really proud of myself when I went from 100 minutes to 600 milliseconds for the test combination '1789,37,47,1889'. Still - it did not scale. But I learned a few things from it, that are valid for a large number of iterations:

* instead of `for($d = 0; $d -lt $departures.Length; $d ++)` assign the `$departures.Length` to a variable first, and then use in the loop. It gave me a stable iteration time (~8s vs ~8-11s)

    ```powershell
    $busLines = $departures.Length
    for($d = 0; $d -lt $busLines; $d ++) {}
    ```

* avoid type casting within the loop, like:

    ```powershell
    if(($cycles[$d] + 1) -ge ([int]$departures[$d] + 1))
    {
        $cycles[$d] = ($departures[$d] -eq 0 ? 0 : 1)
    }
    ```

    instead - convert all numbers to int upfront:

    ```powershell
    $departures = ($departures | ForEach-Object {$_ -eq 'x' ? 0 : [int]$_})
    ```

    during the tests with '1789,37,47,1889' example I went down from 37 seconds per X iterations to 16 second when numbers were cast to int. I gained additional 6-8 seconds converting X to 0 (to have all values as numbers)

I searched for the solutions and below are the examples I adopted for my code.

## Solution 1 - using LCM (Least Common Multiplier)

When I realised, that instead of analysing every timestamp I can analyse the timestamp of the first bus (B1) and cycle every B1 I did not see, that the solution is a step ahead. I analysed differences, sums, coefficients and so on, but LCM was a hit in a head when I saw the solution.

An example. Say we have three buses: 2, 3, 5. We want to find a solution, where [2] is our first bus, [3] is a minute later, [5] is 2 minutes later.

Analyse each timestamp (ts) starting from 0. `.` == no bus, `D` == bus arrived

```cmd
 ts | bus [2] | bus [3] | bus [5]
  0 |    D    |    D    |    D
  1 |    .    |    .    |    .
  2 |    D    |    .    |    .
  3 |    .    |    D    |    .
  4 |    D    |    .    |    .
  5 |    .    |    .    |    D
  6 |    D    |    D    |    .
  7 |    .    |    .    |    .
  8 |    D    |    .    |    .    <-- the solution
  9 |    .    |    D    |    .
 10 |    D    |    .    |    D

```

To find the 8'th iteration I can:

* go from 0, increment by 1 - I will find the solution after 8 iterations
* go from 2 (my bus), increment by 2 (I check buses starting from bus 2) - I will find the solution after 4 iterations
* go from 2 (my bus) - realise that bus [3] is on required position, switch to bus [3], remember I have bus[2] * bus[3] == 6 (LCM) and check bus[5]; I see that bus[5] is not in place (position 4), so I must check **the next moment, when bus[2] and bus[3]** have the same position and check for bus [5] - I will find the solution after 1 iteration.

The trick is with the LCM - when I multiplied positions of bus[2] and bus[3] when they were on the required positions. The steps are as follows:

```cmd
 ts | bus [2] | bus [3] | bus [5]
  2 |    D    |    .    |    .    <-- starting point
  3 |    .    |    D    |    .        I see, that bus[3] is on the position - so bus[3] 1 minute after bus[2] will appear every 6 minutes (2 * 3)
  4 |    D    |    .    |    .        Bus 5 is not there, keep loking, jump 6 minutes from 2 (our starting point)
 ...|
  8 |    D    |    .    |    .    <-- the solution
  9 |    .    |    D    |    .
 10 |    D    |    .    |    D   
```

It's enough to do 1 jump to find the solution. Let's analyse it again for bus[2] and bus[3]

```cmd
 ts | bus [2] | bus [3]
  0 |    D    |    D
  1 |    .    |    .
  2 |    D    |    .    <-- combination [c1]
  3 |    .    |    D
  4 |    D    |    .
  5 |    .    |    .
  6 |    D    |    D
  7 |    .    |    .
  8 |    D    |    .    <-- combination [c2] == [c1] + 6 (2 * 3)
  9 |    .    |    D
 10 |    D    |    .
 11 |    .    |    .
 12 |    D    |    D
 13 |    .    |    .
 14 |    D    |    .    <-- combination [c3] == [c2] + 6
 15 |    .    |    D
 16 |    D    |    .
 17 |    .    |    .
 18 |    D    |    D
 19 |    .    |    .
 20 |    D    |    .    <-- combination [c4] == [c3] + 6
 21 |    .    |    D
```

bus[2] and bus[3] are on the required positions every 6 timestamps. Analysing timestamps in-between is a waste of time.

How about four buses? Say: `2, 3, 5, x, 9`. The solution timestamp is 68, and we can find it in 3 steps.

```cmd
 ts | bus [2] | bus [3] | bus [5] |    X    | bus [9]
  2 |    D    |    .    |    .    |    .    |    .    <-- starting point, bus 3 in place, bus 5 not, LCM = 2 * 3 == 6, jump to 8 (2 + 6)
  3 |    .    |    D    |    .    |    .    |    .
  4 |    .    |    .    |    .    |    .    |    .

  8 |    D    |    .    |    .    |    .    |    .    <-- buses 2, 3, 5 in place, bus 9 not, LCM = 6 * 5 == 30, jump to 38 (8 + 30)
  9 |    .    |    D    |    .    |    .    |    .
 10 |    .    |    .    |    D    |    .    |    .
 11 |    .    |    .    |    .    |    .    |    .
 12 |    .    |    .    |    .    |    .    |    .

 38 |    D    |    .    |    .    |    .    |    .    <-- buses 2, 3, 5 in place, bus 9 not, LCM = 6 * 5 == 30, jump to 68 (38 + 30)
 39 |    .    |    D    |    .    |    .    |    .
 40 |    .    |    .    |    D    |    .    |    .
 41 |    .    |    .    |    .    |    .    |    .
 42 |    .    |    .    |    .    |    .    |    .

 68 |    D    |    .    |    .    |    .    |    .    <-- buses 2, 3, 5, 9 in place
 69 |    .    |    D    |    .    |    .    |    .
 70 |    .    |    .    |    D    |    .    |    .
 71 |    .    |    .    |    .    |    .    |    .
 72 |    .    |    .    |    .    |    .    |    D
```

Done. In three steps after the starting point. Solution is based on [an answer by imbadatreading](https://www.reddit.com/r/adventofcode/comments/kc4njx/2020_day_13_solutions/gfth69h/?utm_source=reddit&utm_medium=web2x&context=3)

>Python solution for pt2, which I think is fairly concise and understandable:
>
>```python
>data = open('input.txt', 'r').read().split('\n')
>data = data[1].split(',')
>B = [(int(data[k]), k) for k in range(len(data)) if data[k] != 'x']
>
>lcm = 1
>time = 0    
>for i in range(len(B)-1):
>    bus_id = B[i+1][0]
>    idx = B[i+1][1]
>    lcm *= B[i][0]
>    while (time + idx) % bus_id != 0:
>        time += lcm
>print(time)
>```

## Solution 2: Chinese Remainder Theorem (CRT)

The CRT was present in many answers. As it's something new for me I started searching and learning.

First thing: CRT works for **the coprime integers**. I wasn't paying attention to the values itself, but after I read this I checked, and all the examples and my input had only prime numbers (as seen on <https://www.mathsisfun.com/prime_numbers.html>). So it's not a coincidence. But why bother, if we have a solution? As [wikipedia states](https://en.wikipedia.org/wiki/Chinese_remainder_theorem):

>The Chinese remainder theorem is widely used for computing with large integers, as it allows replacing a computation for which one knows a bound on the size of the result by several similar computations on small integers.

But first things first.

* Prime numbers - it's clear: 1, 2, 3, 5, 7, 11, ... numbers that are divisible only by 1 and itself.
* Coprime numbers: ...

## Solution 3: Diophantine equations
