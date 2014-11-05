#!/usr/bin/env ruby

require_relative "lib/lexical_analysis.rb"
require_relative "lib/syntactic_analysis.rb"

if(ARGV.length == 0)
  print "Please enter an algebraic expression.\n"
  print "Example ./ruby-algebra-parser 12*-1*(12+(10+20)^2)/100\n"
  print "The parser supports (+-*/^), integers, and floats.\n"
else
  while(ARGV.length != 0)
    expression = ARGV.shift.dup
    print "= Raw Expression =\n#{expression}\n\n"
    print "= Abstract Syntax Tree =\n"
    tokens = lexical_analysis(expression)
#   tokens.each do |x|
#   p x
#   end
    print "#{syn_print(syntactic_analysis(tokens),0)}"
  end
end

