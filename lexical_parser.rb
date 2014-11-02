#!/usr/bin/ruby

# Classes
# =======

class Token
  attr_reader :value, :type

  def initialize(value, type)
    @value = value
    @type = type
  end
end

# Lexical analyser
# ================

def lexical_analysis(parser_input)
  parser_state = nil
  parser_output = []
  current_token = ""

  while parser_input != ""
    case parser_input
    when /^[0-9.]/
      while(parser_input.match(/^[0-9.]/))
        if(parser_input.match(/^[0-9]/))
          if(parser_state == nil)
            parser_state = :integer
          end
          current_token += parser_input[0]
          parser_input[0] = ''
        elsif(parser_input.match(/^\./))
          if(parser_state == :integer)
            current_token += parser_input[0]
            parser_state = :float
            parser_input[0] = ''
          elsif(parser_state == :float)
            print "=== Parser Error ===\n"
            print "A float may contain only one decimal point\n"
            exit
          else
            parser_state = :float
            current_token += "0."
            parser_input[0] = ''
          end
        end
      end
      parser_output.push(Token.new(current_token, parser_state))
      parser_state = nil
      current_token = ""
    when /^[+*^\/]/
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
      parser_output.push(Token.new("(", :parens_open))
      parser_input[0] = ''
    when /^[)]/
      parser_output.push(Token.new(")", :parens_close))
      parser_input[0] = ''
    else
      parser_input[0] = ''
    end
  end

  return parser_output
end

# Syntactic analysis
# ==================

def grammar_valid?(token_array)
# Run a grammar check; validate that the given token array obeys the following
# rules:
#   + may not have consecutive operator or operand tokens
#   + an operator token must precede a parens open token
#   + equal number of opening and closing parantheses
#   + an operand token must succede a parens close token
#   
#   n 7 7; y 7 +; n 7 (; y 7 )
#   y + 7; n + +; y + (; n + )
#   y ( 7; n ( +; y ( (; n ( )
#   n ) 7; y ) +; n ) (; y ) )
#
  token_array.each_index do |i|
    if i == token_array.length-1
      break
    end
    case token_array[i].type
    when :float, :integer
      if(token_array[i+1].type == :float || token_array[i+1].type == :integer)
        print "=== Grammar error ===\n"
        print "Expression contains consecutive operands\n"
        return 0
      end
      if(token_array[i+1].type == :parens_open)
        print "=== Grammar error ===\n"
        print "An opening parethesis cannot succede an operand\n"
        return 0
      end
    when :operator
      if(token_array[i+1].type == :operator)
        print "=== Grammar error ===\n"
        print "Expression contains consecutive operators\n"
        return 0
      end
      if(token_array[i+1].type == :parens_close)
        print "=== Grammar error ===\n"
        print "A closing paranthesis cannot succede an operator\n"
        return 0
      end
    when :parens_open
      if(token_array[i+1].type == :operator)
        print "=== Grammar error ===\n"
        print "An operator may not succede an opening parentheses\n"
        return 0
      end
      if(token_array[i+1].type == :parens_close)
        print "=== Grammar error ===\n"
        print "A closing parenthesis may not succede an opening parenthesis\n"
        return 0
      end
    when :parens_close
      if(token_array[i+1].type == :integer || token_array[i+1].type == :float)
        print "=== Grammar error ===\n"
        print "An operand may not succede a closing parenthesis\n"
        return 0
      end
      if(token_array[i+1].type == :parens_open)
        print "=== Grammar error ===\n"
        print "An opening parenthesis may not succede a closing parenthesis\n"
        return 0
      end
    end
  end

# Check that parentheses have valid placements
  parens_placement = []
  token_array.each do |i|
    if i.type == :parens_open
      parens_placement.push(:parens_open)
    end
    if i.type == :parens_close
      if parens_placement.last == nil
        print "=== Grammar error ===\n"
        print "Expected prior :parens_open token\n"
        return 0
      end
      parens_placement.pop
    end
  end
  if parens_placement.last != nil
    print "=== Grammar error ===\n"
    print "Not all opened parantheses are closed\n"
    return 0
  end

  return 1
end

def syntactic_analysis(parser_input)
  if(grammar_valid?(parser_input) == 1)
    print "=== Grammar check ===\n"
    print "Expression is gramatically valid\n"
    # do fing hear
  end
end

expression = "12*-1*(3.5+4.5)^2+("
print "=== Raw espression ===\n#{expression}\n\n=== Lexer output ===\n"
tokenized = lexical_analysis(expression)
tokenized.each do |x|
  p x
end
syntactic_analysis(tokenized)

