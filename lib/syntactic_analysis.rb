#!/usr/bin/env ruby

require_relative "syntactic_analysis/grammar.rb"
require_relative "syntactic_analysis/tree_class.rb"

def syn_step(syn_input)
  print "=== Syntaxer input ===\n"
  p syn_input
  print "\n\n"
  loop do
    while(syn_input[0].type == :parens_open &&
      syn_input[-1].type == :parens_close)
      syn_input = syn_input[1..-2]
    end
    if(syn_input.length == 1)
      if(syn_input[0].type == :subexpression)
        syn_input = syn_input[0].value
      else
        # it must be an integer or a float
        # sanity check
        if(syn_input[0].type == :integer || syn_input[0].type == :float)
          return TreeLeaf.new(syn_input[0].type, syn_input[0].value)
        else
          # failed sanity check
          # we somehow obtained a terminal node with a non-terminal element
          print "=== Syntactic error ===\n"
          print "Expected an integer or a float token as a terminal node\n"
        end
      end
    else
      break
    end
  end

=begin
  paren_open_index = nil
  paren_close_index = nil
  paren_depth = 0
  syn_input.each_index do |i|
    if(syn_input[i].type == :parens_open)
      paren_open_index = i if paren_depth == 0
      paren_depth += 1
    end
    if(syn_input[i].type == :parens_close)
      paren_close_index = i if paren_close_index == nil
      paren_close_index = i if i > paren_close_index
      paren_depth -=1
      if paren_depth == 0
        if(paren_open_index == 0)
          syn_input = [Token.new(:subexpression,
            syn_input[0..paren_close_index])] +
            syn_input[paren_close_index+1..-1]
        elsif(paren_close_index == syn_input.length-1)
          syn_input = syn_input[0..paren_open_index-1] +
            [Token.new(:subexpression, syn_input[paren_open_index..-1])]
        else
          syn_input = syn_input[0..paren_open_index-1] +
            [Token.new(:subexpression,
            syn_input[paren_open_index..paren_close_index])] +
            syn_input[paren_close_index+1..-1]
        end
        
      end
    end
  end
=end

=begin
  if(paren_open_index == 0)
    syn_input = [Token.new(:subexpression, syn_input[0..paren_close_index])] +
      syn_input[paren_close_index+1..-1]
  elsif(paren_close_index == syn_input.length-1)
    syn_input = syn_input[0..paren_open_index-1] +
      [Token.new(:subexpression, syn_input[paren_open_index..-1])]
  else
    syn_input = syn_input[0..paren_open_index-1] +
      [Token.new(:subexpression,
        syn_input[paren_open_index..paren_close_index])] +
      syn_input[paren_close_index+1..-1]
=end

  return syn_input
end

def syntactic_analysis(parser_input)
  if(grammar_valid?(parser_input) == 1)
    abs_syn_tree = syn_step(parser_input)
    
  else
    return nil
  end
end

