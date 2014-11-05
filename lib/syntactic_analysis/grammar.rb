#!/usr/bin/ruby

def grammar_valid?(token_array)
  token_array.each_index do |i|
    if(i == token_array.length-1)
      if(token_array[i].type != :operator)
        break
      else
        print "=== Grammar error ===\n"
        print "Expression may not end in an operand\n"
        return 0
      end
    end
    case token_array[i].type
    when :float, :integer
      if(token_array[i+1].type == :float || token_array[i+1].type == :integer)
        print "=== Grammar error ===\n"
        print "Expression contains consecutive operands\n\n"
        return 0
      end
      if(token_array[i+1].type == :parens_open)
        print "=== Grammar error ===\n"
        print "An opening parethesis cannot succede an operand\n\n"
        return 0
      end
    when :operator
      if(token_array[i+1].type == :operator)
        print "=== Grammar error ===\n"
        print "Expression contains consecutive operators\n\n"
        return 0
      end
      if(token_array[i+1].type == :parens_close)
        print "=== Grammar error ===\n"
        print "A closing paranthesis cannot succede an operator\n\n"
        return 0
      end
    when :parens_open
      if(token_array[i+1].type == :operator)
        print "=== Grammar error ===\n"
        print "An operator may not succede an opening parentheses\n\n"
        return 0
      end
      if(token_array[i+1].type == :parens_close)
        print "=== Grammar error ===\n"
        print "A closing parenthesis may not succede an opening parenthesis"
        print "\n\n"
        return 0
      end
    when :parens_close
      if(token_array[i+1].type == :integer || token_array[i+1].type == :float)
        print "=== Grammar error ===\n"
        print "An operand may not succede a closing parenthesis\n\n"
        return 0
      end
      if(token_array[i+1].type == :parens_open)
        print "=== Grammar error ===\n\n"
        print "An opening parenthesis may not succede a closing parenthesis"
        print "\n\n"
        return 0
      end
    end
  end

  parens_placement = []
  token_array.each do |i|
    if i.type == :parens_open
      parens_placement.push(:parens_open)
    end
    if i.type == :parens_close
      if parens_placement.last == nil
        print "=== Grammar error ===\n"
        print "Expected prior :parens_open token\n\n"
        return 0
      end
      parens_placement.pop
    end
  end
  if parens_placement.last != nil
    print "=== Grammar error ===\n"
    print "Not all opened parantheses are closed\n\n"
    return 0
  end

  return 1
end

