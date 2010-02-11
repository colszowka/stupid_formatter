require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'stupid_formatter'

class Test::Unit::TestCase
  #
  # Loads fixture files into a string
  #
  def fixtures(filename)
    @fixtures ||= {} # Initialize cache if not present
    return @fixtures[filename.to_sym] if @fixtures[filename.to_sym] # Return if cached
    @fixtures[filename.to_sym] = File.read( File.join(File.dirname(__FILE__), 'fixtures', "#{filename}.txt") )
  end
end
