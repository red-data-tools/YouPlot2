module YouPlot2
  module Aggregation
    extend self

    private alias NaturalToken = Tuple(Symbol, String)

    PURE_NUMBER_PATTERN = /\A[+-]?(?:\d+(?:\.\d+)?|\.\d+)\z/

    # Count occurrences in an array and return [labels, counts] sorted by count desc.
    def count_values(arr : Array(String?), reverse : Bool = false) : Array(Array(String?))
      tally = Hash(String, Int32).new(0)
      arr.each { |v| tally[v || ""] += 1 }

      sorted = tally.to_a.sort do |left_entry, right_entry|
        r = right_entry[1] <=> left_entry[1]
        r == 0 ? natural_compare(left_entry[0], right_entry[0]) : r
      end
      sorted.reverse! if reverse

      labels = sorted.map { |k, _| k.as(String?) }
      counts = sorted.map { |_, v| v.to_s.as(String?) }
      [labels, counts]
    end

    private def natural_compare(a : String, b : String) : Int32
      a_kind = classify_label(a)
      b_kind = classify_label(b)

      # Fast path: text-only labels.
      return compare_strings(a, b) if a_kind == :text && b_kind == :text

      # Fast path: pure numeric labels.
      if a_kind == :numeric && b_kind == :numeric
        r = compare_decimal_strings(a, b)
        return r == 0 ? compare_strings(a, b) : r
      end

      # Fallback: mixed labels (e.g. chr2 vs chr10).
      ta = natural_tokens(a)
      tb = natural_tokens(b)
      max = {ta.size, tb.size}.max

      0.upto(max - 1) do |i|
        xa = ta[i]?
        xb = tb[i]?

        return -1 if xa.nil?
        return 1 if xb.nil?

        kind_a, token_a = xa
        kind_b, token_b = xb

        r = if kind_a == :num && kind_b == :num
              compare_integer_strings(token_a, token_b)
            else
              compare_strings(token_a, token_b)
            end

        return r unless r == 0
      end

      compare_strings(a, b)
    end

    private def compare_strings(a : String, b : String) : Int32
      if r = a <=> b
        r
      else
        0
      end
    end

    private def compare_decimal_strings(a : String, b : String) : Int32
      a_negative, a_integer, a_fraction = decimal_parts(a)
      b_negative, b_integer, b_fraction = decimal_parts(b)
      return a_negative ? -1 : 1 if a_negative != b_negative

      result = a_integer.size <=> b_integer.size
      result = compare_strings(a_integer, b_integer) if result == 0
      if result == 0
        max_digits = Math.max(a_fraction.size, b_fraction.size)
        (0...max_digits).each do |i|
          a_digit = a_fraction[i]? || '0'
          b_digit = b_fraction[i]? || '0'
          result = a_digit.ord <=> b_digit.ord
          break unless result == 0
        end
      end
      a_negative ? -result : result
    end

    private def decimal_parts(value : String) : {Bool, String, String}
      negative = value.starts_with?('-')
      unsigned = value.starts_with?('+') || negative ? value[1..] : value
      parts = unsigned.split('.', 2)
      integer = parts[0].sub(/\A0+/, "")
      integer = "0" if integer.empty?
      fraction = (parts[1]? || "").sub(/0+\z/, "")
      negative = false if integer == "0" && fraction.empty?
      {negative, integer, fraction}
    end

    private def classify_label(s : String) : Symbol
      return :text unless s.each_char.any?(&.ascii_number?)
      return :numeric if s.matches?(PURE_NUMBER_PATTERN)

      :mixed
    end

    private def natural_tokens(s : String) : Array(NaturalToken)
      return [{:text, ""}] if s.empty?

      tokens = [] of NaturalToken
      buffer = ""
      current_kind = :text
      first = true

      s.each_char do |char|
        kind = char.ascii_number? ? :num : :text
        if first
          current_kind = kind
          buffer = char.to_s
          first = false
          next
        end

        if kind == current_kind
          buffer += char
        else
          tokens << {current_kind, buffer}
          current_kind = kind
          buffer = char.to_s
        end
      end

      tokens << {current_kind, buffer}
      tokens
    end

    private def compare_integer_strings(a : String, b : String) : Int32
      aa = a.sub(/\A0+/, "")
      bb = b.sub(/\A0+/, "")
      aa = "0" if aa.empty?
      bb = "0" if bb.empty?

      r = aa.size <=> bb.size
      return r unless r == 0

      r = compare_strings(aa, bb)
      return r unless r == 0

      compare_strings(a, b)
    end
  end
end
