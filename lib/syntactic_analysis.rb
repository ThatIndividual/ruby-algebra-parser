#!/usr/bin/env ruby

require_relative "syntactic_analysis/grammar.rb"
require_relative "syntactic_analysis/tree_class.rb"

def syntactic_analysis(parser_input)
  if(grammar_valid?(parser_input) == 1)
    
  else
    return nil
  end
end

