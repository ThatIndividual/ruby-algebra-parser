#!/usr/bin/env ruby

require_relative "lib/lexical_analysis.rb"
require_relative "lib/syntactic_analysis.rb"

expression = "((12+13)/5)+1"

print "=== Raw espression ===\n#{expression}\n\n=== Lexer output ===\n"

tokens = lexical_analysis(expression)
tokens.each do |x|
  p x
end
print "\n"

abstract_syntax_tree = syntactic_analysis(tokens)
p abstract_syntax_tree

