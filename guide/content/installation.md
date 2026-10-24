---
title: Installation
description: Download YouPlot2 or build it from source with Crystal and Shards.
---

{{< guidenav current="installation" >}}

Download the executable for your system from [GitHub Releases](https://github.com/red-data-tools/YouPlot2/releases). The command in this guide is `uplot2`; add the downloaded executable to your `PATH`, and make it executable on macOS or Linux if needed.

To build from source, install Crystal and Shards, then run:

```sh
git clone https://github.com/red-data-tools/YouPlot2.git
cd YouPlot2
shards install
shards build
bin/uplot2 --version
```

{{< guidenav current="installation" >}}
