---
title: Introduction
---

YouPlot2 is a command-line plotting tool for the terminal. It reads tab-separated data from standard input or a file. Use `--delimiter ,` for comma-separated data and `--headers` if the first row contains column names.

The main commands are `bar`, `hist`, `line`, `lines`, `scatter`, `density`, `box`, and `count`. Run `uplot2 --help` for the full list, or `uplot2 <command> --help` for command options.

Plots go to standard error by default, so they remain visible when standard output is piped elsewhere. Use `--output -` to send a plot to standard output, or `--output FILE` to save it.
