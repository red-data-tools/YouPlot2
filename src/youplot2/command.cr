module YouPlot2
  class Command
    getter command : String?
    getter params : Parameters
    getter options : Options
    getter data : Data?

    def initialize(@argv : Array(String) = ARGV.dup)
      @params = Parameters.new
      @options = Options.new
      @command = nil
      @data = nil
      @progressive_initialized = false
      @progressive_headers = nil
      @progressive_series = [] of Array(String?)
      @progressive_header_consumed = false
      @progressive_row_count = 0
      @progressive_current_input = nil.as(IO?)
    end

    def run
      parser = Parser.new(@argv, @params, @options)
      parser.parse

      @command = parser.command
      cmd = @command
      input_files = parser.input_files

      if cmd.nil?
        parser.show_main_help(STDERR)
        return
      end

      # colors subcommand – no input data needed
      if ["colors", "color", "colours", "colour"].includes?(cmd)
        output_colors
        return
      end

      if options.progressive?
        process_progressive_input(input_files, cmd)
        return
      end

      # Read from files given on the command line, or from stdin.
      # Multiple files are treated as one continuous stream for a single plot.
      input = read_all_input(input_files)
      process_input(input, cmd)
    ensure
      finalize_streams
    end

    private def process_input(input : String, cmd : String)
      output_data(input)
      @data = DSV.parse(input, options.delimiter, options.headers, options.transpose?)

      STDERR.puts @data.inspect if options.debug?

      plot = create_plot(cmd)
      output_plot(plot)
    end

    private def process_progressive_input(input_files : Array(String), cmd : String)
      previous_lines = 0
      cursor_hidden = false

      if options.output_path
        raise UsageError.new("progressive mode cannot write plots to --output FILE")
      end

      exit_reason = nil.as(Process::ExitReason?)
      Process.on_terminate do |reason|
        exit_reason = reason
        close_progressive_input(@progressive_current_input)
      end

      output_io.print "\e[?25l"
      cursor_hidden = true

      previous_lines = read_progressive_inputs(input_files, cmd, previous_lines) { !!exit_reason }

      sanitize_progressive_output(previous_lines, cursor_hidden)
      cursor_hidden = false
      if reason = exit_reason
        exit progressive_exit_code(reason)
      end
    ensure
      sanitize_progressive_output(previous_lines || 0, cursor_hidden) if cursor_hidden
      @progressive_current_input = nil
      Process.restore_interrupts!
    end

    private def read_progressive_inputs(input_files : Array(String), cmd : String,
                                        previous_lines : Int32, &stop : -> Bool) : Int32
      if input_files.empty?
        return read_progressive_io(STDIN, cmd, previous_lines, stop)
      end

      input_files.each do |path|
        break if stop.call

        File.open(path) do |file|
          previous_lines = read_progressive_io(file, cmd, previous_lines, stop)
        end
      rescue ex : File::Error
        raise InputError.new("failed to read #{path.inspect}: #{ex.message}", cause: ex)
      end

      previous_lines
    end

    private def read_progressive_io(io : IO, cmd : String,
                                    previous_lines : Int32, stop : -> Bool) : Int32
      @progressive_current_input = io
      io.each_line(chomp: false) do |line|
        break if stop.call
        previous_lines = process_progressive_line(line, cmd, previous_lines)
      end

      previous_lines
    rescue ex : IO::Error
      return previous_lines if stop.call
      raise InputError.new("failed while reading progressive input: #{ex.message}", cause: ex)
    ensure
      @progressive_current_input = nil
    end

    private def progressive_exit_code(reason : Process::ExitReason) : Int32
      case reason
      when .interrupted?
        130
      when .session_ended?
        143
      when .terminal_disconnected?
        129
      else
        1
      end
    end

    private def close_progressive_input(input : IO?) : Nil
      return unless input
      input.close unless input.closed?
    rescue
      # The signal may arrive while the stream is already closing.
    end

    private def process_progressive_line(input : String, cmd : String, previous_lines : Int32) : Int32
      output_data(input)

      row = parse_progressive_row(input)
      return previous_lines unless row

      @data = progressive_update_data(row)
      return previous_lines unless @data

      STDERR.puts @data.inspect if options.debug?

      plot = create_plot(cmd)
      lines = output_plot_progressive(plot)
      output_io.print "\e[#{lines}F" if lines > 0
      lines
    end

    private def sanitize_progressive_output(previous_lines : Int32, cursor_hidden : Bool) : Nil
      return if options.output.closed?

      if previous_lines > 0
        output_io.print "\e[#{previous_lines}E"
      end
      output_io.print "\e[0J"
      output_io.print "\e[?25h" if cursor_hidden
      output_io.flush
    end

    private def parse_progressive_row(input : String) : Array(String?)?
      rows = CSV.parse(input, separator: options.delimiter)
      row = rows.first?
      return unless row

      values = row.map { |value| value.as(String?) }
      return if values.empty? || values.all?(Nil)

      values
    rescue ex : CSV::Error
      raise DataError.new("failed to parse progressive input row: #{ex.message}", cause: ex)
    end

    private def progressive_update_data(row : Array(String?)) : Data?
      init_progressive_state

      return if consume_progressive_header?(row)

      append_progressive_row(row)
      progressive_data
    end

    private def init_progressive_state
      return if @progressive_initialized

      @progressive_initialized = true
      @progressive_headers = options.headers ? [] of String : nil
      @progressive_series = [] of Array(String?)
      @progressive_header_consumed = false
      @progressive_row_count = 0
    end

    private def consume_progressive_header?(row : Array(String?)) : Bool
      return false unless options.headers
      return false if options.transpose?
      return false if @progressive_header_consumed

      @progressive_headers = row.map { |value| value || "" }
      @progressive_header_consumed = true
      true
    end

    private def append_progressive_row(row : Array(String?)) : Nil
      if options.headers && options.transpose?
        if headers = @progressive_headers
          headers << (row[0]? || "")
        end
        @progressive_series << row[1..]
      elsif options.transpose?
        @progressive_series << row
      else
        append_progressive_columns(row)
      end
    end

    private def progressive_data : Data?
      headers = @progressive_headers
      series = @progressive_series

      if headers
        STDERR.puts "Headers contains empty string in it.".colorize(:magenta) if headers.any?(&.empty?)

        h_size = headers.size
        s_size = series.size

        if h_size > s_size
          raise DataError.new("the number of headers is greater than the number of data series (headers: #{h_size}, series: #{s_size})")
        elsif h_size < s_size
          raise DataError.new("the number of headers is less than the number of data series (headers: #{h_size}, series: #{s_size})")
        end
      end

      Data.new(headers, series)
    end

    private def append_progressive_columns(row : Array(String?)) : Nil
      if row.size > @progressive_series.size
        (@progressive_series.size...row.size).each do
          @progressive_series << Array(String?).new(@progressive_row_count, nil)
        end
      end

      @progressive_series.each_with_index do |series, i|
        series << row[i]?
      end

      @progressive_row_count += 1
    end

    private def create_plot(cmd : String) : ::UnicodePlot::Plot
      case cmd
      when "bar", "barplot"
        Backends::UnicodePlot.barplot(data!, params, options.fmt)
      when "count", "c"
        Backends::UnicodePlot.barplot(data!, params, count: true, reverse: options.reverse?)
      when "hist", "histogram"
        Backends::UnicodePlot.histogram(data!, params)
      when "line", "lineplot", "l"
        Backends::UnicodePlot.line(data!, params, options.fmt)
      when "lines", "lineplots", "ls"
        Backends::UnicodePlot.lines(data!, params, options.fmt)
      when "scatter", "s"
        Backends::UnicodePlot.scatter(data!, params, options.fmt)
      when "density", "d"
        Backends::UnicodePlot.density(data!, params, options.fmt)
      when "box", "boxplot"
        Backends::UnicodePlot.boxplot(data!, params)
      else
        raise UsageError.new("unrecognized command '#{cmd}'")
      end
    end

    private def output_colors
      output_io.print(Backends::UnicodePlot.colors(options.color_names?))
    end

    private def data! : Data
      @data || raise DataError.new("no data loaded")
    end

    private def read_input_file(path : String) : String
      File.read(path)
    rescue ex : File::Error
      raise InputError.new("failed to read #{path.inspect}: #{ex.message}", cause: ex)
    end

    private def read_all_input(input_files : Array(String)) : String
      return STDIN.gets_to_end if input_files.empty?

      String.build do |io|
        input_files.each do |path|
          io << read_input_file(path)
        end
      end
    end

    private def output_data(input : String)
      if io = pass_io
        io.print(input)
      end
    end

    private def output_plot(plot : ::UnicodePlot::Plot)
      ::UnicodePlot.show_plot(output_io, plot)
      output_io.puts
    end

    private def output_plot_progressive(plot : ::UnicodePlot::Plot) : Int32
      buffer = IO::Memory.new
      ::UnicodePlot.show_plot(buffer, plot, use_color: output_io.tty?)
      lines = buffer.to_s.lines

      lines.each do |line|
        output_io.print line.chomp
        output_io.print "\e[0K"
        output_io.puts
      end
      output_io.print "\e[0J"
      output_io.flush

      lines.size
    end

    private def pass_io : IO?
      if io = options.pass
        return io
      end

      if path = options.pass_path
        options.pass = open_output_file(path, "--pass")
      end
    end

    private def output_io : IO
      if options.output.object_id == STDERR.object_id
        if path = options.output_path
          options.output = open_output_file(path, "--output")
        end
      end

      options.output
    end

    private def open_output_file(path : String, option : String) : IO
      File.open(path, "w")
    rescue ex : File::Error
      raise InputError.new("failed to open #{path.inspect} from #{option}: #{ex.message}", cause: ex)
    end

    private def finalize_streams
      finalize_io(options.output)
      if io = options.pass
        finalize_io(io)
      end
    end

    private def finalize_io(io : IO)
      io.flush
      return if io.object_id == STDOUT.object_id
      return if io.object_id == STDERR.object_id
      io.close unless io.closed?
    rescue
      # Ignore close/flush errors during teardown.
    end
  end
end
