---
title: Plots in your terminal
description: YouPlot2 draws plots from tabular data. Pipe in values or read a file.
---

{{< guidenav current="index" >}}

YouPlot2 draws plots from tabular data. Pipe in values or read a file.

<pre class="terminal-output">$ printf 'F%s\t%s\n' \
  1 1  2 1  3 2 \
  4 3  5 5  6 8 \
  7 13 8 21 9 34 | uplot2 bar

      ┌                                        ┐
   F1 ┤■ 1
   F2 ┤■ 1
   F3 ┤■■ 2
   F4 ┤■■■ 3
   F5 ┤■■■■■ 5
   F6 ┤■■■■■■■■ 8
   F7 ┤■■■■■■■■■■■■■■ 13
   F8 ┤■■■■■■■■■■■■■■■■■■■■■■ 21
   F9 ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 34
      └                                        ┘</pre>

{{< guidenav current="index" >}}
