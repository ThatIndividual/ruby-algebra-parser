#!/usr/bin/env ruby

class TreeRoot
  attr_accessor :child

  def initialize(child)
      @child = child
  end
end

class TreeBranch
  attr_accessor :type, :children

  def initialize(type, children)
      @type = type
      @children = children
  end
end

class TreeLeaf
  attr_accessor :type, :value

  def initialize(type, value)
    @type = type
    @value = value
  end
end
