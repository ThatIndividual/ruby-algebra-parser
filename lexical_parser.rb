#!/usr/bin/ruby

class Token
  attr_reader :value, :type

  def initialize(value, type)
    @value = value
    @type = type
  end
end

def lexical_parse(parser_input)
  parser_state = []
  parser_output = []
  current_token = ""

  while parser_input != ""
    case parser_input
    when /^[0-9.]/
      while(parser_input.match(/^[0-9.]/))
        if(parser_input.match(/^[0-9]/))
          if(parser_state.last != :integer && parser_state.last != :float)
            parser_state.push(:integer)
          end
          current_token += parser_input[0]
          parser_input[0] = ''
        elsif(parser_input.match(/^\./))
          if(parser_state.last == :integer)
            current_token += parser_input[0]
            parser_state[-1] = :float
            parser_input[0] = ''
          elsif(parser_state.last == :float)
            print "=== Parser Error ===\n"
            print "A float may contain only one decimal point\n"
            exit
          else
            parser_state.push(:float)
            current_token += "0."
            parser_input[0] = ''
          end
        end
      end
      parser_output.push(Token.new(current_token, parser_state.pop))
      current_token = ""
    when /^[+*\/]/
      parser_output.push(Token.new(parser_input[0], :operator))
      parser_input[0] = ''
    when /^[-]/
      if(parser_output.last.type==:operator && parser_input.match(/^-[0-9.]/))
        current_token = "-"
      else
        parser_output.push(Token.new("-", :operator))
      end
      parser_input[0] = ''
    when /^[(]/
      parser_state.push(:parens_open)
      parser_output.push(Token.new("(", :parens_open))
      parser_input[0] = ''
    when /^[)]/
      if(parser_state.last == :parens_open)
        parser_state.pop
        parser_output.push(Token.new(")", :parens_close))
        parser_input[0] = ''
      else
        print "=== Parser error ===\n"
        print "The expression has too many closing parens\n"
        exit
      end
    else
      parser_input[0] = ''
    end
  end

  if(parser_state.last == :parens_open)
    print "=== Parser error ===\n"
    print "The expression has too many opening parens\n"
    exit
  end
  return parser_output
end

tokenized = lexical_parse("12*-1*(3.5+4.5)-12/6")
tokenized.each do |x|
  p x
end
