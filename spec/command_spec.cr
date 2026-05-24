require "./spec_helper"

SIMPLE_INPUT = "1\t2\n3\t4\n"

def temp_command_path(prefix : String) : String
  File.join(Dir.tempdir, "youplot2-#{prefix}-#{Process.pid}-#{Time.utc.to_unix_ms}-#{Random.rand(1_000_000)}.txt")
end

describe YouPlot2::Command do
  it "treats multiple input files as one data stream" do
    input1_path = temp_command_path("multi-input-1")
    input2_path = temp_command_path("multi-input-2")
    combined_output_path = temp_command_path("multi-output-combined")
    split_output_path = temp_command_path("multi-output-split")

    begin
      File.write(input1_path, "1\t2\n")
      File.write(input2_path, "3\t4\n")

      # Equivalent to old per-file plotting behavior.
      YouPlot2::Command.new(["line", "--output", split_output_path, input1_path]).run
      YouPlot2::Command.new(["line", "--output", split_output_path, input2_path]).run
      split_output = File.read(split_output_path)

      # Current behavior should parse concatenated inputs and produce one plot.
      YouPlot2::Command.new(["line", "--output", combined_output_path, input1_path, input2_path]).run
      combined_output = File.read(combined_output_path)

      combined_output.should_not eq(split_output)
    ensure
      File.delete(input1_path) if File.exists?(input1_path)
      File.delete(input2_path) if File.exists?(input2_path)
      File.delete(combined_output_path) if File.exists?(combined_output_path)
      File.delete(split_output_path) if File.exists?(split_output_path)
    end
  end

  it "reads the input before opening --pass FILE" do
    input_path = temp_command_path("pass-input")
    output_path = temp_command_path("pass-output")
    original = SIMPLE_INPUT
    File.write(input_path, original)

    begin
      YouPlot2::Command.new(["line", "--output", output_path, "--pass", input_path, input_path]).run
      File.read(input_path).should eq(original)
    ensure
      File.delete(input_path) if File.exists?(input_path)
      File.delete(output_path) if File.exists?(output_path)
    end
  end

  it "reads the input before opening --output FILE" do
    input_path = temp_command_path("output-input")
    expected_output_path = temp_command_path("output-expected")
    original = SIMPLE_INPUT

    begin
      File.write(input_path, original)
      YouPlot2::Command.new(["line", "--output", expected_output_path, input_path]).run
      expected = File.read(expected_output_path)

      File.write(input_path, original)
      YouPlot2::Command.new(["line", "--output", input_path, input_path]).run

      File.read(input_path).should eq(expected)
    ensure
      File.delete(input_path) if File.exists?(input_path)
      File.delete(expected_output_path) if File.exists?(expected_output_path)
    end
  end
end
