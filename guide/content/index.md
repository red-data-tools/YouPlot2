---
title: Plots in your terminal
---

YouPlot2 draws plots from tabular data. Pipe in values or read a file.

<pre class="terminal-output">$ printf 'F1\t1\nF2\t1\nF3\t2\nF4\t3\nF5\t5\nF6\t8\nF7\t13\nF8\t21\nF9\t34\n' | uplot2 bar

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

[Quick Start](quickstart.html) · [Installation](installation.html) · [Introduction](introduction.html)
