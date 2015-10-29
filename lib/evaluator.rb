class Evaluator
  def initialize(input_file, output_file='')
    @input_file = input_file
    @output_file = output_file.nil? || output_file.empty? ? 'rpn.csv' : output_file
  end

  def run
    cell_array.each do |tokens|
      tokens.each do |token|
        value = process_token(copy_of_token(token), {})
        token.clear << value
      end
    end
    output
  end

  def process_token(tokens, ref_hash)
    calc_stack = []
    tokens.push(0) if tokens.empty?
    until tokens.last.nil?
      elem = tokens.pop
      case "#{elem}"
      when '+', '-', '*', '/'
        calc_stack.push(rpn_calc(calc_stack.pop, calc_stack.pop, elem))
      when /^[-+]?[0-9]*\.?[0-9]+$/
        calc_stack.push(elem.to_f)
      when /^([a-z])(\d+)$/
        r = fetch_or_process(Regexp.last_match, ref_hash)
        calc_stack.push(r)
        break if r == '#ERR'
      else
        calc_stack.push('#ERR')
        break
      end
    end
    if calc_stack.size == 1 && tokens.last.nil?
      tokens.push(calc_stack.last)
    else
      tokens.pop until tokens.last.nil?
      tokens.push('#ERR')
    end
    tokens.last
  end

  private

  def cell_array
    @cell_array ||= [].tap do |result|
      File.open(@input_file, 'r') do |f|
        f.each_line do |line|
          row = []
          line.chomp.split(/,/).each do |tokens|
            row << tokens.split(/ /).reject(&:empty?).reverse!
          end
          result << row
        end
      end
    end
  end

  def rpn_calc(op1, op2, operator)
    if op1.nil? || op2.nil?
      '#ERR'
    else
      calc(op2.to_f, op1.to_f, operator)
    end
  end

  def calc(op1, op2, operator)
    case operator
    when '+'
      op1 + op2
    when '-'
      op1 - op2
    when '*'
      op1 * op2
    when '/'
      op2 == 0 ? '#ERR' : (op1 / op2)
    end
  end

  def fetch_or_process(last_match, ref_hash)
    row = last_match[2].to_i - 1
    col = last_match[1].ord - 'a'.ord
    if cell_array[row].nil? || cell_array[row][col].nil?
      '#ERR'
    elsif valid_cell_value?(cell_array[row][col])
      cell_array[row][col][0]
    else
      if ref_hash.has_key?(last_match[0])
        '#ERR'
      else
        ref_hash[last_match[0]] = 1
        process_token(copy_of_token(cell_array[row][col]), ref_hash)
      end
    end
  end

  def valid_cell_value?(t)
    t.size == 1 && (t[0] == '#ERR' || "#{t[0]}" =~ /^[-+]?[0-9]*\.?[0-9]+$/)
  end

  def copy_of_token(token)
    [].tap do |result|
      token.each do |t|
        result << t
      end
    end
  end

  def output
    File.open("#{@output_file}", 'w+') do |f|
      cell_array.each do |tokens|
        tokens.flatten!
        tokens.map!{|t| "#{t}" =~ /^[-+]?[0-9]*\.?0+$/ ? t.to_i : t}
        f.puts tokens.join(',')
      end
    end
  end
end
