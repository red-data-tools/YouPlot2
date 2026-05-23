require "./spec_helper"

describe YouPlot2::Aggregation do
  describe ".count_values" do
    it "uses natural sort for ties in mixed labels" do
      labels, counts = YouPlot2::Aggregation.count_values([
        "a10", "a2", "a1",
      ])

      labels.should eq(["a1", "a2", "a10"] of String?)
      counts.should eq(["1", "1", "1"] of String?)
    end

    it "uses numeric order for pure numeric labels" do
      labels, counts = YouPlot2::Aggregation.count_values([
        "10", "2", "1",
      ])

      labels.should eq(["1", "2", "10"] of String?)
      counts.should eq(["1", "1", "1"] of String?)
    end

    it "supports reverse option after natural sorting" do
      labels, _ = YouPlot2::Aggregation.count_values([
        "a10", "a2", "a1",
      ], reverse: true)

      labels.should eq(["a10", "a2", "a1"] of String?)
    end
  end
end
