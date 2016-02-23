$LOAD_PATH.unshift(File.dirname(__FILE__))
# require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
# require_relative '../bin/hyde'


class HydeTest < Minitest::Test

  def test_args_contains_desired_action
    # binding.pry
    submitted = Hyde.new(build)
  end

end
