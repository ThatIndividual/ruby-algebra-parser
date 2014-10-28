#!/usr/bin/ruby

class Token
  attr_reader :value, :type

  def initialize(value, type)
    @value = value
    @type = type
  end
end

def lexical_parse(input_string)
  input = input_string
  parser_state = []
  parser_output = []
  current_token = ""

  while input != ""
    if input.match('^[0-9]')
      parser_state.push(:integer)
      while input.match('^[0-9.]')
        if input.match('^[0-9]')
          current_token += input[0]
          input[0] = ''
        elsif input.match('^\.')
          case parser_state.last
          when :integer
            parser_state.pop
            parser_state.push(:float)
            current_token += "."
            input[0] = ''
          when :float
            print "=== Parser Error ===\n" + 
              "A float may contain only one decimal point\n"
            exit
          else
            print "=== Parser Error ===\n" +
              "Expected :integer or :float when reading decimal place\n" +
              "Got #{parser_state.last}\n"
          end
        end
      end
      parser_output.push(Token.new(current_token, parser_state.pop))
      current_token = ''
    else
      input[0] = ''
    end
  end

  return parser_output
end

tokenized = lexical_parse("12*(3.5+4.5)-12/6")
tokenized.each do |x|
  p x
end
