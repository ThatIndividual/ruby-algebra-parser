#!/usr/bin/env ruby

require_relative "lexical_analysis/token.rb"

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
      parser_output.push(Token.new(parser_state, current_token))
      parser_state = nil
      current_token = ""
    when /^[+*^\/]/
      parser_output.push(Token.new(:operator, parser_input[0]))
      parser_input[0] = ''
    when /^[-]/
      if(parser_output.length > 0)
        if(parser_output.last.type==:operator && parser_input.match(/^-[0-9.]/))
          current_token = "-"
        else
          parser_output.push(Token.new(:operator, "-"))
        end
      else
        current_token = "-"
      end
      parser_input[0] = ''
    when /^[(]/
      parser_output.push(Token.new(:parens_open, "("))
      parser_input[0] = ''
    when /^[)]/
      parser_output.push(Token.new(:parens_close, ")"))
      parser_input[0] = ''
    else
      parser_input[0] = ''
    end
  end

  return parser_output
end

