require 'minitest'

class MiniTestWorld
  extend MiniTest::Assertions

  attr_accessor :assertions

  def initialize
    @assertions = 0
  end
end

World do
  MiniTestWorld.new
end
