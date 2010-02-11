$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'stupid_formatter'

require 'test/unit/assertions'

World(Test::Unit::Assertions)
