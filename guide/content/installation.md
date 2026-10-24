---
title: Installation
description: Download YouPlot2 or build it from source with Crystal and Shards.
---

{{< guidenav current="installation" >}}

Select your system to install the prebuilt v0.0.6 release. The version shown here is updated when the guide is built. You can also browse [GitHub Releases](https://github.com/red-data-tools/YouPlot2/releases).

Before running these commands, add `$HOME/.local/bin` (or `$HOME\bin` on Windows) to your `PATH` so you can run `uplot2` directly.

<div class="install-tabs" role="group" aria-label="Operating system">
<input type="radio" name="install-os" id="install-linux" checked><label for="install-linux">Linux</label>
<input type="radio" name="install-os" id="install-mac-arm"><label for="install-mac-arm">macOS ARM</label>
<input type="radio" name="install-os" id="install-mac-intel"><label for="install-mac-intel">macOS Intel</label>
<input type="radio" name="install-os" id="install-windows"><label for="install-windows">Windows</label>

<div class="install-panel install-linux"><pre>curl -fLO https://github.com/red-data-tools/YouPlot2/releases/download/v0.0.6/youplot2-v0.0.6-x86_64-unknown-linux-musl.tar.gz
tar -xzf youplot2-v0.0.6-x86_64-unknown-linux-musl.tar.gz
mkdir -p "$HOME/.local/bin"
install -m 755 youplot2-v0.0.6-x86_64-unknown-linux-musl/uplot2 "$HOME/.local/bin/uplot2"
rm -r youplot2-v0.0.6-x86_64-unknown-linux-musl.tar.gz youplot2-v0.0.6-x86_64-unknown-linux-musl
uplot2 --version</pre></div>

<div class="install-panel install-mac-arm"><pre>curl -fLO https://github.com/red-data-tools/YouPlot2/releases/download/v0.0.6/youplot2-v0.0.6-aarch64-apple-darwin.tar.gz
tar -xzf youplot2-v0.0.6-aarch64-apple-darwin.tar.gz
mkdir -p "$HOME/.local/bin"
install -m 755 youplot2-v0.0.6-aarch64-apple-darwin/uplot2 "$HOME/.local/bin/uplot2"
rm -r youplot2-v0.0.6-aarch64-apple-darwin.tar.gz youplot2-v0.0.6-aarch64-apple-darwin
uplot2 --version</pre></div>

<div class="install-panel install-mac-intel"><pre>curl -fLO https://github.com/red-data-tools/YouPlot2/releases/download/v0.0.6/youplot2-v0.0.6-x86_64-apple-darwin.tar.gz
tar -xzf youplot2-v0.0.6-x86_64-apple-darwin.tar.gz
mkdir -p "$HOME/.local/bin"
install -m 755 youplot2-v0.0.6-x86_64-apple-darwin/uplot2 "$HOME/.local/bin/uplot2"
rm -r youplot2-v0.0.6-x86_64-apple-darwin.tar.gz youplot2-v0.0.6-x86_64-apple-darwin
uplot2 --version</pre></div>

<div class="install-panel install-windows"><pre>Invoke-WebRequest 'https://github.com/red-data-tools/YouPlot2/releases/download/v0.0.6/youplot2-v0.0.6-x86_64-pc-windows-msvc.zip' -OutFile 'youplot2-v0.0.6-x86_64-pc-windows-msvc.zip'
Expand-Archive 'youplot2-v0.0.6-x86_64-pc-windows-msvc.zip' -DestinationPath 'youplot2-v0.0.6-x86_64-pc-windows-msvc' -Force
New-Item "$HOME\bin" -ItemType Directory -Force | Out-Null
Copy-Item 'youplot2-v0.0.6-x86_64-pc-windows-msvc\uplot2.exe' "$HOME\bin\uplot2.exe" -Force
Remove-Item 'youplot2-v0.0.6-x86_64-pc-windows-msvc.zip', 'youplot2-v0.0.6-x86_64-pc-windows-msvc' -Recurse
uplot2 --version</pre></div>
</div>

To build from source, install Crystal and Shards, then run:

```sh
git clone https://github.com/red-data-tools/YouPlot2.git
cd YouPlot2
shards install
shards build
bin/uplot2 --version
```

{{< guidenav current="installation" >}}
