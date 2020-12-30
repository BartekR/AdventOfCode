# Second challenge solution

My initial idea (get a big hammer and do it brute-force == check all possibilities) was extremely slow - analysing 1.2 mln combinations in 1 minute. It was enough for the first example, but the second was a stopper. I tried some analysis on how to exclude some combinations, but all were inefficient.

After AoC 2020 finished I started looking how others did it. There were trees involved, but three of the solutions looked were cool and short:

* [by ACProctor](https://www.reddit.com/r/adventofcode/comments/ka8z8x/2020_day_10_solutions/gfd237l/?utm_source=reddit&utm_medium=web2x&context=3)
* [by digtydoo](https://www.reddit.com/r/adventofcode/comments/ka8z8x/2020_day_10_solutions/gfcxuxf/?utm_source=reddit&utm_medium=web2x&context=3)
* [by jsut_](https://www.reddit.com/r/adventofcode/comments/ka8z8x/2020_day_10_solutions/gfcaqju/?utm_source=reddit&utm_medium=web2x&context=3)

I implemented them, and this description is for me to remember what and how. Descriptions contain citations of the original solutions, for documentation purposes.

## Solution #1 (based on ACProctor code)

>Ruby
>
>I haven't seen someone posting a solution like mine, so I figured I'd share my approach.
>
>I have the answers for both Part 1 and Part 2 in O(n log n) time, and only one copy of the data in RAM.
>
>First, I read the list, and sorted it. (this is where the n log n comes in via quick sort).
>
>```ruby
>#start with outlet (joltage = 0)
>numbers = [0]
>File.open('day10.data').each do |line|
>  next if(line.nil?)
>  md = line.match(/([0-9]+)/)
>  if(!md.nil?)
>    numbers << md[1].to_i
>  end
>end
>
>numbers.sort!
>
># add device (highest joltage +3)
>numbers << numbers[-1] + 3
>```
>
>Then for part 1, I ran through the entire list, and counted when the delta between each item was 1 or 3.
>
>```ruby
>puts "Part 1"
>three_count = 0
>one_count = 0
>(0..numbers.length-2).each do |i|
>    delta = numbers[i+1] - numbers[i]
>    if(delta > 3)
>        puts "Invalid sequence, can't continue from #{numbers[i]} to #{numbers[i+1]}"
>    elsif(delta == 3)
>        three_count += 1
>    elsif(delta == 1)
>        one_count += 1
>    end
>end
>puts "#{three_count} 3-jolt jumps * #{one_count} 1-jolt jumps = #{three_count*one_count}"
>```
>
>For part 2, I figured that I could derive a mathematical proof by focusing on how many valid combinations you could make within sequences of contiguous numbers. 1,2,3,4,5 has the same number of combinations as 11,12,13,14,15 so the actual >numbers don't matter just the length of the sequence.
>
>I started to build out some data to see if I could come up with a theorem for what the valid combinations would be given our rules would be. After figuring out the number of combinations sequences of 1,2,3,4 and 5 consecutive numbers would >produce, I decided to check the data to see what the maximum length of a sequence was that I'd have to figure out.
>
>It turns out that my input data's longest sequence of consecutive numbers was 5. So rather than coming up with a formula and a proof, I was able to just create an array of values for 1-5 length sequences, and return the combination in O(1) >time. permute_map = [1,1,1,2,4,7]
>
>Having my "formula" to determine complexity of each sequence, I just went back to my loop I had created for part 1, and any time I noticed a 3-number jump between numbers, I multiplied my total combinations value by the mapped value from the >length of the sequence.
>
>```ruby
>three_count = 0
>one_count = 0
>max_length = 0
>cur_length = 0
>permute_map = [1,1,1,2,4,7]
>total_combos = 1
>
>(0..numbers.length-2).each do |i|
>    cur_length += 1
>    delta = numbers[i+1] - numbers[i]
>    if(delta == 3)
>        three_count += 1
>
>        total_combos *= permute_map[cur_length]
>
>        max_length = cur_length if cur_length > max_length
>        cur_length = 0        
>    elsif(delta == 1)
>        one_count += 1
>    end
>end
>
>puts "Part 1: #{three_count} 3-jolt jumps * #{one_count} 1-jolt jumps = #{three_count*one_count}"
>puts "Part 2: Total Combos = #{total_combos}"
>```

### My understanding and explanation

What is this permutation_map? How did he get it? As it's 1 to 5 element combinations I did it by hand using pen and paper.

5 elements combinations:

```cmd
1 2 3 4 5 <-- all elements        (1 combination)
1 2 3 4   <-- remove one element  (5 combinations)
1 2 3   5
1 2   4 5
1   3 4 5
  2 3 4 5
1 2 3     <-- remove two elements (10 combinations)
1 2   4
1 2     5
1   3 4
1   3   5
1     4 5
  2 3 4
  2 3   5
  2   4 5
    3 4 5
1 2       <-- remove three elements (10 combinations)
1   3
1     4
1       5
  2 3
  2   4
  2     5
    3 4
    3   5
      4 5
```

I don't remove 4 elements, as it would break the max-3-jolts-distance rule. Adding the combinations (1 + 5 + 10 + 10) I get 26, so why ACProctor says it's 7?

Because we have either 3-jolts gap or 1-jolt gap (as seen in the first solution - I got 33 1-jolt and 72 3-jolt ). When we analyse series, we have to retain the options, where both boundary values (1, 5) are present - to connect with the previous and following jolts that are 3-jolts gap away. So when we count all the ways with 1 and 5 element present we get 8 combinations. But - there is one exception: `1       5` combination - we have to remove it from the list, because `5 - 1 > 3`, so we can't use this option. Hence - we get 7 combinations.

The same applies to 4 elements:

```cmd
1 2 3 4 <-- all elements (1 combination)
1 2 3   <-- remove 1 element (4 combinations)
1 2   4
1   3 4
  2 3 4
1 2     <-- remove 2 elements (6 combinations)
1   3
1     4
  2 3
  2   4
    3 4
```

I don't remove 3 elements, as I would have no both boundaries (1, 4) present. Total combinations: 1 + 4 + 6 == 11, but only 4 combinations hold boundary elements.

3 elements:

```cmd
1 2 3 <-- all elements (1 combination)
1 2   <-- remove 1 element (3 combinations)
1   3
  2 3
```

4 combinations in total, 2 of them hold boundary elements. For 2 elements and 1 element we have only 1 combinations each that hold boundary element(s).

So - we have this array of permutations: [1, 1, 2, 4, 7] for the series of elements: (1, 2, 3, 4, 5).

The last thing is we have to multiply the permutations by the number of already found solutions.

## Solution #2 (based on digtydoo's code)

>Python
>
>I'm extremely proud of my solution for part 2. Just sort the list and for each adapter, sum how many paths each of the adapters "before" this one has. Start with paths[0] = 1, and in the end get the path of max_joltage (max of the input + 3)
>
>```python
># paths[n] is the total paths from 0 to n
>paths = defaultdict(int)
>paths[0] = 1
>
>for adapter in sorted(adapters):
>    for diff in range(1, 4):
>        next_adapter = adapter + diff
>        if next_adapter in adapters:
>            paths[next_adapter] += paths[adapter]
>print(paths[max_voltage])
>```

Counting the paths before the current adapter. Using two loops - external for adapters, internal for jolt differences.

## Solution #3 (based on jsut_'s code)

>Perl for part 2
>
>This seems far simpler than what a lot of people did.
>
>```perl
>use 5.18.4;
>use strict;
>use File::Slurp;
>
>my @lines = read_file('input');
>@lines = sort {$a <=> $b} @lines;
>@lines = map { chomp $_; $_ } sort {$a <=> $b} @lines;
>push @lines, $lines[-1] + 3;
>
>my %routes = (0 => 1);
>
>foreach my $i (@lines) {
>    $routes{$i} = $routes{$i-1} + $routes{$i-2} + $routes{$i-3};
>    say "$i: $routes{$i}"
>}
>```

It's a sum of the ways to get to the three jolts before. Looks like the solution #2, but without the inner loop (diff)- using three different calculated paths

## Additional notes

I've seen one term here and there: [tribonacci sequence](https://en.wikipedia.org/wiki/Generalizations_of_Fibonacci_numbers#Tribonacci_numbers), which is an extension to the [Fibonacci sequence](https://en.wikipedia.org/wiki/Fibonacci_number). Plus [Lazy caterer's sequence](https://en.wikipedia.org/wiki/Lazy_caterer%27s_sequence).

Tribonacci and Lazy caterer have the same sequence of numbers in common: 1, 2, 4, 7. Both algorithms works for the AoC, as the longest 1-jolt streaks were 4 or 5 and manipulating the assumptions both solutions provide correct solutions. So - how it works for 6-element streak?

```cmd
Fibonacci:    0, 1, 1, 2,  3,  5,  8, 13, 21, ...
Tribonacci:   0, 0, 1, 2,  4,  7, 13, 24, 44, ...
Lazy caterer: 1, 2, 4, 7, 11, 16, 22, 29, 37, ...
```

6 elements - let's stick just to combinations, that contain boundaries (1, 6) - meaning we can consider 1, 2 and 3 elements combinations. We can't remove 4 elements, as would stay only with the boundaries, and `6 - 1 > 3`.

```cmd
1 2 3 4 5 6 <-- all elements (1 combination)
1 2 3 4   6 <-- remove 1 element (4 combinations of 6 possible)
1 2 3   5 6
1 2   4 5 6
1   3 4 5 6
1 2 3     6 <-- remove 2 elements (6 combinations of 15 possible)
1 2     5 6
1     4 5 6
1 2   4   6
1   3 4   6
1   3   5 6
1     4   6 <-- remove 3 elements (4 combinations of 20 possible, but only 2 valid)
1   3     6
1 2       6 <<< invalid, 6 - 2 > 3
1       5 6 <<< invalid, 5 - 1 > 3
```

We get 1 + 4 + 6 + 2 == 13 combinations - looks like **tribonacci**. So, last test with 7 elements (again - keeping only combinations with the boundary elements). If we are correct the result should be 24.

```cmd
1 2 3 4 5 6 7 <-- all elements (1 combination)
1 2 3 4 5   7 <-- remove 1 element (5 combinations of 7 possible)
1 2 3 4   6 7
1 2 3   5 6 7
1 2   4 5 6 7
1   3 4 5 6 7
1 2 3 4     7 <-- remove 2 elements (10 combinations of 21 possible)
1 2 3   5   7
1 2 3     6 7
1 2   4 5   7
1 2   4   6 7
1 2     5 6 7
1   3 4 5   7
1   3 4   6 7
1   3   5 6 7
1     4 5 6 7
1 2 3       7 <-- remove 3 elements (10 combinations of 35 possible, 7 correct) <<< invalid, 7 - 3 > 3
1 2   4     7
1 2     5   7
1 2       6 7 <<< invalid, 6 - 2 > 3
1   3 4     7
1   3   5   7
1   3     6 7
1     4 5   7
1     4   6 7
1       5 6 7 << invalid, 5 - 1 > 3
1   3       7 <-- remove 4 elements (4 combinations of 35 possible, 1 correct) <<< invalid, 7 - 3 > 3
1     4     7
1       5   7 <<< invalid, 5 - 1 > 3
1         6 7 <<< invalid, 6 - 1 > 3
```

Total: 1 + 5 + 10 + 7 + 1 == 24. So - it's tribonacci.

Still - I don't know why it works here. Maybe it's related to counting the previous 3 paths?

One more example with dynamic programming - very well explained on YT by [hey_programmers](https://www.youtube.com/watch?v=_f8N7qo_5hA)

### The trees

The examples with the dynamic programming, solutions by jsut_ and digtydoo use trees and the summaries of paths for previous (or next) jolts. How does it work?

The idea: for each next jolt we add values for positions [jolt - 1], [jolt - 2], [jolt - 3] (or [jolt + 1], [jolt + 2], [jolt + 3] like on YT video). Below are the steps in the calculation with the paths explanations.

Example using (sorted) jolts: 1,4,5,6,7,10,11,12,15,16,19,(22) - 22 is the device, we don't use socket (0), we assume the value 1 for socket.

step. `adapter[jolts] == calculations + path(s)`

0. `adapter[0] == 1 (initial value)`
1. `adapter[1] == adapter[0] + adapter[-1] + adapter[-2] == 1 + 0 + 0 == 1`

    ```cmd
    path:  0 <- 1 (adapter[0])
    ```

2. `adapter[4] == adapter[3] + adapter[2] + adapter[1] == 0 + 0 + 1 == 1`

    ```cmd
    path:  0 <- 1 <- 4 (adapter[1])
    ```

3. `adapter[5] == adapter[4] + adapter[3] + adapter[2] == 1 + 0 + 0 == 1`

    ```cmd
    path:  0 <- 1 <- 4 <- 5 (adapter[4])
    ```

4. `adapter[6] == adapter[5] + adapter[4] + adapter[3] == 1 + 1 + 0 == 2`

    ``` cmd
    paths: 0 <- 1 <- 4 <- 5 <- 6 (adapter[5])
           0 <- 1 <- 4      <- 6 (adapter[4])
    ```

5. `adapter[7] == adapter[6] + adapter[5] + adapter[4] == 2 + 1 + 1 == 4`

    ```cmd
    paths: 0 <- 1 <- 4 <- 5 <- 6 <- 7 (adapter[6])
           0 <- 1 <- 4      <- 6 <- 7 (adapter[6])
           0 <- 1 <- 4 <- 5      <- 7 (adapter[5])
           0 <- 1 <- 4           <- 7 (adapter[4])
    ```

6. `adapter[10] == adapter[9] + adapter[8] + adapter[7] == 0 + 0 + 4 == 4`

    ```cmd
    paths: 0 <- 1 <- 4 <- 5 <- 6 <- 7 <- 10 (adapter[7])
           0 <- 1 <- 4      <- 6 <- 7 <- 10 (adapter[7])
           0 <- 1 <- 4 <- 5      <- 7 <- 10 (adapter[7])
           0 <- 1 <- 4           <- 7 <- 10 (adapter[7])
    ```

7. `adapter[11] == adapter[10] + adapter[9] + adapter[8] == 4 + 0 + 0 == 4`

    ```cmd
    paths: 0 <- 1 <- 4 <- 5 <- 6 <- 7 <- 10 <- 11 (adapter[10])
           0 <- 1 <- 4      <- 6 <- 7 <- 10 <- 11 (adapter[10])
           0 <- 1 <- 4 <- 5      <- 7 <- 10 <- 11 (adapter[10])
           0 <- 1 <- 4           <- 7 <- 10 <- 11 (adapter[10])
    ```

8. `adapter[12] == adapter[11] + adapter[10] + adapter[9] == 4 + 4 + 0 == 8`

    ```cmd
    paths: 0 <- 1 <- 4 <- 5 <- 6 <- 7 <- 10 <- 11 <- 12 (adapter[11])
           0 <- 1 <- 4      <- 6 <- 7 <- 10 <- 11 <- 12 (adapter[11])
           0 <- 1 <- 4 <- 5      <- 7 <- 10 <- 11 <- 12 (adapter[11])
           0 <- 1 <- 4           <- 7 <- 10 <- 11 <- 12 (adapter[11])
           0 <- 1 <- 4 <- 5 <- 6 <- 7 <- 10       <- 12 (adapter[10])
           0 <- 1 <- 4      <- 6 <- 7 <- 10       <- 12 (adapter[10])
           0 <- 1 <- 4 <- 5      <- 7 <- 10       <- 12 (adapter[10])
           0 <- 1 <- 4           <- 7 <- 10       <- 12 (adapter[10])
    ```

9. `adapter[15] == adapter[14] + adapter[13] + adapter[12] == 0 + 0 + 8`

    ```cmd
    paths: 0 <- 1 <- 4 <- 5 <- 6 <- 7 <- 10 <- 11 <- 12 <- 15 (adapter[12])
           0 <- 1 <- 4      <- 6 <- 7 <- 10 <- 11 <- 12 <- 15 (adapter[12])
           0 <- 1 <- 4 <- 5      <- 7 <- 10 <- 11 <- 12 <- 15 (adapter[12])
           0 <- 1 <- 4           <- 7 <- 10 <- 11 <- 12 <- 15 (adapter[12])
           0 <- 1 <- 4 <- 5 <- 6 <- 7 <- 10       <- 12 <- 15 (adapter[12])
           0 <- 1 <- 4      <- 6 <- 7 <- 10       <- 12 <- 15 (adapter[12])
           0 <- 1 <- 4 <- 5      <- 7 <- 10       <- 12 <- 15 (adapter[12])
           0 <- 1 <- 4           <- 7 <- 10       <- 12 <- 15 (adapter[12])
    ```cmd

10. `adapter[16] == adapter[15] + adapter[14] + adapter[13] == 8 + 0 + 0 == 8`

    ```cmd
    paths: 0 <- 1 <- 4 <- 5 <- 6 <- 7 <- 10 <- 11 <- 12 <- 15 <- 16 (adapter[15])
           0 <- 1 <- 4      <- 6 <- 7 <- 10 <- 11 <- 12 <- 15 <- 16 (adapter[15])
           0 <- 1 <- 4 <- 5      <- 7 <- 10 <- 11 <- 12 <- 15 <- 16 (adapter[15])
           0 <- 1 <- 4           <- 7 <- 10 <- 11 <- 12 <- 15 <- 16 (adapter[15])
           0 <- 1 <- 4 <- 5 <- 6 <- 7 <- 10       <- 12 <- 15 <- 16 (adapter[15])
           0 <- 1 <- 4      <- 6 <- 7 <- 10       <- 12 <- 15 <- 16 (adapter[15])
           0 <- 1 <- 4 <- 5      <- 7 <- 10       <- 12 <- 15 <- 16 (adapter[15])
           0 <- 1 <- 4           <- 7 <- 10       <- 12 <- 15 <- 16 (adapter[15])
    ```

11. `adapter[19] == adapter[18] + adapter[17] + adapter[16] == 0 + 0 + 8 == 8`

    ```cmd
    paths: 0 <- 1 <- 4 <- 5 <- 6 <- 7 <- 10 <- 11 <- 12 <- 15 <- 16 <- 19 (adapter[16])
           0 <- 1 <- 4      <- 6 <- 7 <- 10 <- 11 <- 12 <- 15 <- 16 <- 19 (adapter[16])
           0 <- 1 <- 4 <- 5      <- 7 <- 10 <- 11 <- 12 <- 15 <- 16 <- 19 (adapter[16])
           0 <- 1 <- 4           <- 7 <- 10 <- 11 <- 12 <- 15 <- 16 <- 19 (adapter[16])
           0 <- 1 <- 4 <- 5 <- 6 <- 7 <- 10       <- 12 <- 15 <- 16 <- 19 (adapter[16])
           0 <- 1 <- 4      <- 6 <- 7 <- 10       <- 12 <- 15 <- 16 <- 19 (adapter[16])
           0 <- 1 <- 4 <- 5      <- 7 <- 10       <- 12 <- 15 <- 16 <- 19 (adapter[16])
           0 <- 1 <- 4           <- 7 <- 10       <- 12 <- 15 <- 16 <- 19 (adapter[16])
    ```

The answer: we can connect the adapters in 8 ways.
