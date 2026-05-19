require "./spec_helper"

describe "barplot value labels" do
  it "formats all-integer bar values as integers" do
    output = render_barplot("a\t3\nb\t7\nc\t12\n")

    output.should contain(" 3 ")
    output.should contain(" 7 ")
    output.should contain(" 12 ")
    output.should_not contain("3.0")
    output.should_not contain("7.0")
    output.should_not contain("12.0")
  end

  it "treats explicit float bar values as floats" do
    output = render_barplot("a\t3.0\nb\t7.0\nc\t12.0\n")

    output.should contain(" 3.0 ")
    output.should contain(" 7.0 ")
    output.should contain(" 12.0 ")
  end

  it "treats mixed integer and float bar values as floats" do
    output = render_barplot("a\t3\nb\t3.0\nc\t12\n")

    output.should contain(" 3.0 ")
    output.should contain(" 12.0 ")
  end
end

private def render_barplot(input : String) : String
  data = YouPlot2::DSV.parse(input, '\t', nil, false)
  plot = YouPlot2::Backends::UnicodePlot.barplot(data, YouPlot2::Parameters.new)
  io = IO::Memory.new
  ::UnicodePlot.show_plot(io, plot, use_color: false)
  io.to_s
end
