require "./spec_helper"

describe "audit CLI rendering" do
  it "uses palette indices and RGB values for bar and box plots" do
    data = YouPlot2::DSV.parse("1\n3\n2\n", '\t', nil, false)
    params = YouPlot2::Parameters.new
    params.color = "196"

    bars = YouPlot2::Backends::UnicodePlot.barplot(data, params)
    bars.graphics.as(::UnicodePlot::BarplotGraphics).colors.should eq(
      [::UnicodePlot.ansi_color(196)] * 3)

    boxes = YouPlot2::Backends::UnicodePlot.boxplot(data, params)
    boxes.graphics.as(::UnicodePlot::BoxplotGraphics).boxes.first.color.should eq(
      ::UnicodePlot.ansi_color(196))

    params.color = "#12aBcD"
    expected = ::UnicodePlot.ansi_color(0x12, 0xab, 0xcd)
    YouPlot2::Backends::UnicodePlot.barplot(data, params).graphics
      .as(::UnicodePlot::BarplotGraphics).colors.should eq([expected] * 3)
    YouPlot2::Backends::UnicodePlot.boxplot(data, params).graphics
      .as(::UnicodePlot::BoxplotGraphics).boxes.first.color.should eq(expected)
  end

  it "lists only supported color names and the 256 palette indices" do
    listing = YouPlot2::Backends::UnicodePlot.colors(true)
    names = listing.gsub(/\e\[[0-9;]*m/, "").split(/\s+/).reject(&.empty?)
    (::UnicodePlot::NAMED_COLORS.keys.map(&.to_s) +
      ["gray", "light_black", "auto", "normal", "default", "nothing"]).each do |name|
      names.should contain(name)
    end
    names.should contain("0")
    names.should contain("255")
    names.should_not contain("bold")
    names.should_not contain("underline")
    names.size.should eq(::UnicodePlot::NAMED_COLORS.size + 6 + 256)
  end

  it "renders the documented Quick Start input as three bars" do
    data = YouPlot2::DSV.parse("1\n3\n2\n", '\t', nil, false)
    plot = YouPlot2::Backends::UnicodePlot.barplot(data, YouPlot2::Parameters.new)
    plot.graphics.as(::UnicodePlot::BarplotGraphics).bars.size.should eq(3)
  end
end
