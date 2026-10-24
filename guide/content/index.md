---
title: YouPlot2
---

<section class="landing" aria-labelledby="landing-title">
  <h2 id="landing-title">Plots in your terminal</h2>
  <p>YouPlot2 draws plots from tabular data. Pipe in values or read a file.</p>

  <div class="terminal-demo" aria-label="YouPlot2 bar chart example">
    <p class="terminal-command"><span>$</span> printf 'F1\t1\nF2\t1\nF3\t2\nF4\t3\nF5\t5\nF6\t8\nF7\t13\nF8\t21\nF9\t34\n' | uplot2 bar</p>
    <pre class="terminal-output"><code>      ┌                                        ┐
   F1 ┤■ 1
   F2 ┤■ 1
   F3 ┤■■ 2
   F4 ┤■■■ 3
   F5 ┤■■■■■ 5
   F6 ┤■■■■■■■■ 8
   F7 ┤■■■■■■■■■■■■■■ 13
   F8 ┤■■■■■■■■■■■■■■■■■■■■■■ 21
   F9 ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 34
      └                                        ┘</code></pre>
  </div>

  <p class="landing-links"><a href="quickstart.html">Quick Start</a> · <a href="installation.html">Installation</a> · <a href="introduction.html">Introduction</a></p>
</section>
