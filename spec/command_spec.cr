require "./spec_helper"

SIMPLE_INPUT = "1\t2\n3\t4\n"

def temp_command_path(prefix : String) : String
  File.join(Dir.tempdir, "youplot2-#{prefix}-#{Process.pid}-#{Time.utc.to_unix_ms}-#{Random.rand(1_000_000)}.txt")
end

describe YouPlot2::Command do
  it "reads a one-row transposed input with headers as one series" do
    data = YouPlot2::DSV.parse("sample\t1\t2\n", '\t', true, true)
    data.headers.should eq(["sample"])
    data.series.should eq([["1", "2"]])
  end

  it "uses all input files around --" do
    first_path = temp_command_path("before-dash")
    second_path = temp_command_path("after-dash")
    begin
      File.write(first_path, "1\t2\n")
      File.write(second_path, "3\t4\n")
      command = YouPlot2::Command.new(["line", first_path, "--", second_path])
      command.options.output = IO::Memory.new
      command.run
      command.data.try(&.series[0].size).should eq(2)
    ensure
      File.delete(first_path) if File.exists?(first_path)
      File.delete(second_path) if File.exists?(second_path)
    end
  end

  it "waits for transposed xy series before progressive plotting" do
    path = temp_command_path("progressive-xy")
    begin
      File.write(path, "1\t2\n3\t4\n")
      ["scatter", "lines", "density"].each do |kind|
        command = YouPlot2::Command.new([kind, "-T", "-p", path])
        command.options.output = IO::Memory.new
        command.run
        command.data.try(&.series.size).should eq(2)
      end
    ensure
      File.delete(path) if File.exists?(path)
    end
  end

  it "waits for complete xyxy pairs and rejects an unmatched final series" do
    path = temp_command_path("progressive-xyxy")
    begin
      File.write(path, "1\t2\n3\t4\n5\t6\n7\t8\n")
      complete = YouPlot2::Command.new(["scatter", "-T", "-p", "--fmt", "xyxy", path])
      complete.options.output = IO::Memory.new
      complete.run
      complete.data.try(&.series.size).should eq(4)

      File.write(path, "1\t2\n3\t4\n5\t6\n")
      incomplete = YouPlot2::Command.new(["scatter", "-T", "-p", "--fmt", "xyxy", path])
      incomplete.options.output = IO::Memory.new
      expect_raises(YouPlot2::DataError, /even number/) { incomplete.run }
    ensure
      File.delete(path) if File.exists?(path)
    end
  end

  it "waits for a complete quoted CSV record in progressive mode" do
    first_path = temp_command_path("csv-part-1")
    second_path = temp_command_path("csv-part-2")
    pass_path = temp_command_path("csv-pass")
    begin
      File.write(first_path, "\"alpha\n")
      File.write(second_path, "beta\",1\n")
      command = YouPlot2::Command.new(["bar", "-p", "-d,", "--pass", pass_path, first_path, second_path])
      command.options.output = IO::Memory.new
      command.run
      command.data.try(&.series[0]).should eq(["alpha\nbeta"])
      File.read(pass_path).should eq("\"alpha\nbeta\",1\n")
    ensure
      [first_path, second_path, pass_path].each do |path|
        File.delete(path) if File.exists?(path)
      end
    end
  end

  it "reports an unfinished quoted record at EOF" do
    path = temp_command_path("csv-unfinished")
    begin
      File.write(path, "\"alpha\nbeta")
      command = YouPlot2::Command.new(["bar", "-p", "-d,", path])
      command.options.output = IO::Memory.new
      expect_raises(YouPlot2::DataError, /Unclosed quote/) { command.run }
    ensure
      File.delete(path) if File.exists?(path)
    end
  end

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

  it "rejects progressive pass targets that alias any input before truncating them" do
    first_path = temp_command_path("progressive-first")
    input_path = temp_command_path("progressive-input")
    symlink_path = temp_command_path("progressive-symlink")
    hardlink_path = temp_command_path("progressive-hardlink")
    original = "1\t#{" " * 5_000}2\n" * 20

    begin
      File.write(first_path, SIMPLE_INPUT)
      File.write(input_path, original)
      File.symlink(input_path, symlink_path)
      File.link(input_path, hardlink_path)

      [input_path, symlink_path, hardlink_path].each do |pass_path|
        command = YouPlot2::Command.new(["line", "-p", "--pass", pass_path, first_path, input_path])
        command.options.output = IO::Memory.new
        ex = expect_raises(YouPlot2::UsageError) { command.run }
        (ex.message || "").should contain("progressive input file")
        File.read(input_path).should eq(original)
        File.read(first_path).should eq(SIMPLE_INPUT)
      end
    ensure
      [first_path, input_path, symlink_path, hardlink_path].each do |path|
        File.delete(path) if File.exists?(path)
      end
    end
  end

  it "reports a buffered output failure instead of reporting success" do
    if File.exists?("/dev/full")
      input_path = temp_command_path("full-input")
      begin
        File.write(input_path, SIMPLE_INPUT)
        stderr = IO::Memory.new
        status = YouPlot2.run(["line", "--output", "/dev/full", input_path], stderr: stderr)
        status.should eq(1)
        stderr.to_s.should contain("I/O error")
      ensure
        File.delete(input_path) if File.exists?(input_path)
      end
    end
  end
end
