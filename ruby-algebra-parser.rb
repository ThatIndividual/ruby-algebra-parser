#!/usr/bin/env ruby

require_relative "lib/lexical_analysis.rb"
require_relative "lib/syntactic_analysis.rb"

expression = "12*-1*(3.5+4.5)^2"

print "=== Raw espression ===\n#{expression}\n\n=== Lexer output ===\n"

tokens = lexical_analysis(expression)
tokens.each do |x|
  p x
end
print "\n"

abstract_syntax_tree = syntactic_analysis(tokens)


