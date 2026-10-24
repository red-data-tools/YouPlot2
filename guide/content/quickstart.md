---
title: Quick Start
description: Try YouPlot2 with runnable commands and terminal output examples.
---

{{< guidenav current="quickstart" >}}

Run these commands in a shell. YouPlot2 draws plots to standard error by default. Plot size and colors can vary with your terminal; the output below omits trailing spaces and the final blank line.

## Fibonacci growth

`printf` turns each pair of numbers into a label and a value, separated by a tab:

```sh
printf 'F%s\t%s\n' \
  1 1  2 1  3 2 \
  4 3  5 5  6 8 \
  7 13 8 21 9 34 | uplot2 bar
```

Output:

<pre class="terminal-output">      <span class="ansi-8">┌                                        ┐</span>
   F1 <span class="ansi-8">┤</span><span class="ansi-2">■ </span>1
   F2 <span class="ansi-8">┤</span><span class="ansi-2">■ </span>1
   F3 <span class="ansi-8">┤</span><span class="ansi-2">■■ </span>2
   F4 <span class="ansi-8">┤</span><span class="ansi-2">■■■ </span>3
   F5 <span class="ansi-8">┤</span><span class="ansi-2">■■■■■ </span>5
   F6 <span class="ansi-8">┤</span><span class="ansi-2">■■■■■■■■ </span>8
   F7 <span class="ansi-8">┤</span><span class="ansi-2">■■■■■■■■■■■■■■ </span>13
   F8 <span class="ansi-8">┤</span><span class="ansi-2">■■■■■■■■■■■■■■■■■■■■■■ </span>21
   F9 <span class="ansi-8">┤</span><span class="ansi-2">■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ </span>34
      <span class="ansi-8">└                                        ┘</span></pre>

## Sine wave

Python 3 generates two columns of sample data, which `line` plots as x and y values:

```sh
python3 - <<'PY' | uplot2 line
from math import pi, sin
for i in range(33):
    x = 2 * pi * i / 32
    print(f'{x:.4f}\t{sin(x):.4f}')
PY
```

Output:

<pre class="terminal-output">      <span class="ansi-8">┌────────────────────────────────────────┐</span>
    <span class="ansi-8">1 │⠀⠀⠀⠀⠀⠀</span><span class="ansi-2">⡠⠊⠉⠉⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">│⠀⠀⠀⠀</span><span class="ansi-2">⢀⠖⠁⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">│⠀⠀⠀</span><span class="ansi-2">⢀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠱⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">│⠀⠀</span><span class="ansi-2">⢀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">│⠀⠀</span><span class="ansi-2">⡎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">│⠀</span><span class="ansi-2">⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">│</span><span class="ansi-2">⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">│</span><span class="ansi-10">⠧</span><span class="ansi-8">⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤</span><span class="ansi-10">⠼⡤</span><span class="ansi-8">⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤</span><span class="ansi-10">⢤</span><span class="ansi-8">⠤⠤⠤⠤│</span>
      <span class="ansi-8">│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-2">⢱⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠃⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-2">⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡎⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-2">⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-2">⠈⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡸⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-2">⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-2">⠈⢦⠀⠀⠀⠀⠀⢀⠜⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
   <span class="ansi-8">-1 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-2">⠑⢄⣀⣀⡠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</span><span class="ansi-8">│</span>
      <span class="ansi-8">└────────────────────────────────────────┘</span>
      ⠀<span class="ansi-8">0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀7⠀</span></pre>

You can also make a histogram or count repeated labels:

```sh
printf '1\n3\n2\n4\n3\n' | uplot2 hist
printf 'red\nblue\nred\n' | uplot2 count
```

To read a file instead of a pipe, run `uplot2 line values.tsv`. Run `uplot2 --help` for all commands, or `uplot2 <command> --help` for command options.

{{< guidenav current="quickstart" >}}
