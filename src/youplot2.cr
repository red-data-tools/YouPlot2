require "unicode_plot"

require "./youplot2/errors"
require "./youplot2/data"
require "./youplot2/parameters"
require "./youplot2/options"
require "./youplot2/dsv"
require "./youplot2/aggregation"
require "./youplot2/backends/unicode_plot"
require "./youplot2/parser"
require "./youplot2/command"
require "./youplot2/runner"

module YouPlot2
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end
