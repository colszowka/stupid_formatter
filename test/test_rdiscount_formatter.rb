require 'helper'

class TestRDiscountFormatter < Test::Unit::TestCase
  context "With a chunk of markdown-formatted text" do
    setup do
      @text = "# some heading"
    end
    
    context "after piping it through a new rdiscount formatter instance" do
      setup do
        @result = StupidFormatter::RDiscount.new(@text).result
      end
      
      should("render '<h1>some heading</h1>'") { assert_equal '<h1>some heading</h1>', @result.strip.chomp }
    end
  end
end
