require 'rdiscount'
require 'erb'
require 'coderay'

class String
  #
  # Pipes this string through the StupidFormatter and it's configured chain.
  # The same as StupidFormatter.result(some_string)
  #
  def formatted
    StupidFormatter.result(self)
  end
end

module StupidFormatter
  class << self
    #
    # Returns the current processing chain. Defaults to [StupidFormatter::Erb, StupidFormatter::RDiscount]
    #
    def chain
      @chain ||= [StupidFormatter::Erb, StupidFormatter::RDiscount]
    end
    
    #
    # Make the formatter chain configurable. Pass in an Array of Formatters in the order
    # you want them processed in.
    #
    def chain=(chain)
      @chain = chain
    end
    
    #
    # Will put the input string through all formatters in the chain
    #
    def result(input)
      output = input.clone
      chain.each do |formatter|
        output = formatter.new(output).result
      end
      output
    end
  end
  
  #
  # Base class for formatters, providing the basic API.
  #
  class AbstractFormatter
    attr_reader :input
    
    def initialize(input)
      @input = input.to_s.strip
      raise "Please use this only in subclasses" if self.class == AbstractFormatter
    end
    
    def result
      raise "This should be implemented by subclasses"
    end
  end
  
  class Erb < AbstractFormatter
    def result(alternative_binding=nil)
      ERB.new(input, 0, "%<>", "@output_buffer").result(alternative_binding || binding)
    end
    
    # Helper for capturing output in a erb block for later use, i.e.
    #   <% @my_var = capture do %>
    #     Bar
    #   <% end %>
    #   Foo<%= @my_var %>
    # will render FooBar.
    #
    def capture
      old_buffer, @output_buffer = @output_buffer, ''
      yield
      @output_buffer
    ensure
      @output_buffer = old_buffer
    end
  end
  
  class RDiscount < AbstractFormatter
    def result
      Markdown.new(input).to_html
    end
  end
  
  module CoderayHelper
    def highlight(language=:ruby)
      code = capture { yield }
      @output_buffer << CodeRay.scan(code, language).div(:css => :class)
    end
  end
end

# Add coderay helper by default
StupidFormatter::Erb.send :include, StupidFormatter::CoderayHelper
