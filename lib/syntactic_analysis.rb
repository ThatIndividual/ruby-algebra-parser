#!/usr/bin/env ruby

require_relative "syntactic_analysis/grammar.rb"
require_relative "syntactic_analysis/tree_class.rb"

def fully_paranthesized?(token_array)
  inside_parens = 0
  if(token_array[0].type == :parens_open &&
    token_array[-1].type == :parens_close)
    token_array.each_index do |i|
      if(token_array[i].type == :parens_open)
        inside_parens += 1
      elsif(token_array[i].type == :parens_close)
        inside_parens -= 1
      end

      if(inside_parens < 1)
        return 0
      end

      if(inside_parens > 0 && i == token_array.length-2)
        return 1
      end
    end
  else
    return 0
  end
end

def syn_step(syn_input)
  loop do
    while(fully_paranthesized?(syn_input) == 1)
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

  paren_open_index  = nil
  paren_close_index = nil
  paren_depth = 0
  i = 0
  loop do
    if(i == syn_input.length)
      break
    end
    if(syn_input[i].type == :parens_open)
      paren_open_index = i if paren_depth == 0
      paren_depth += 1
    end
    if(syn_input[i].type == :parens_close)
      paren_close_index = i if paren_close_index == nil || i > paren_close_index
      paren_depth -= 1
      if(paren_depth == 0)
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
        i = paren_open_index
        paren_open_index  = nil
        paren_close_index = nil
      end
    end
    i += 1
  end

  # check for operators starting at lowest precedence, + -
  syn_input.each_index do |i|
    if(syn_input[i].type == :operator &&
      (syn_input[i].value == "+" || syn_input[i].value == "-"))
      return TreeBranch.new(syn_input[i].value,
        [syn_step(syn_input[0..i-1]),
        syn_step(syn_input[i+1..syn_input.length])])
      break
    end
  end

  # check for operators of precedence 2, * /
  syn_input.each_index do |i|
    if(syn_input[i].type == :operator &&
      (syn_input[i].value == "*" || syn_input[i].value == "/"))
      return TreeBranch.new(syn_input[i].value,
        [syn_step(syn_input[0..i-1]),
        syn_step(syn_input[i+1..syn_input.length])])
      break
    end
  end

  # check for operators of precedence 3, ^
  # ^ is right associative
  syn_input.each_index do |i|
    if(syn_input[i].type == :operator && syn_input[i].value == "^")
      return TreeBranch.new(syn_input[i].value,
        [syn_step(syn_input[0..i-1]),
        syn_step(syn_input[i+1..syn_input.length])])
      break
    end
  end

  return syn_input
end

def syn_print(printer_input, printer_depth)
  if(printer_input.class == TreeBranch)
    print "  " * printer_depth,"└[",printer_input.type,"]\n"
    syn_print(printer_input.children[0], printer_depth+1)
    syn_print(printer_input.children[1], printer_depth+1)
  elsif(printer_input.class == TreeLeaf)
    print "  " * printer_depth,"└[",printer_input.value,"]\n"
  end
end

def syntactic_analysis(parser_input)
  if(grammar_valid?(parser_input) == 1)
    return syn_step(parser_input)
  else
    return nil
  end
end

