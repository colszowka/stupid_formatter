require 'helper'

class TestErbFormatter < Test::Unit::TestCase
  context "A chunk of erb-formatted text" do
    setup do
      @text = "<%= 'foo bar baz' %>"
    end
    
    context "after piping it through a new erb formatter instance" do
      setup do
        @result = StupidFormatter::Erb.new(@text).result
      end
      
      should("render 'foo bar baz'") { assert_equal 'foo bar baz', @result.strip.chomp }
    end
  end
  
  context "A chunk of erb-formatted text that includes a block using the highlight-syntax" do
    setup do
      @text = '<% highlight do %>
puts "foo bar baz"
<% end %>'
    end
    
    context "after piping it through a new erb instance" do
      setup do
        @result = StupidFormatter::Erb.new(@text).result
      end
      
      should('match <div class="CodeRay">') { assert_match /\<div class="CodeRay"\>/, @result.strip.chomp }
    end
  end
end
