---
title: Plots in your terminal
description: YouPlot2 draws plots from tabular data. Pipe in values or read a file.
---

{{< guidenav current="index" >}}

YouPlot2 draws plots from tabular data. Pipe in values or read a file.

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

{{< guidenav current="index" >}}
