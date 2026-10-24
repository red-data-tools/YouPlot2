---
title: Quick Start
---

Pipe one value per line to draw a horizontal bar chart:

```sh
printf '1\n3\n2\n' | uplot2 bar
```

For named bars, put a label and a value on each tab-separated row:

```sh
printf 'Mon\t2\nTue\t4\nWed\t3\n' | uplot2 bar
```

The same one-column input can make a line chart or a histogram:

```sh
printf '1\n3\n2\n' | uplot2 line
printf '1\n3\n2\n' | uplot2 hist
```

You can also read a file, for example `uplot2 line values.tsv`. Add `--output -` to write the plot to standard output instead of standard error.
