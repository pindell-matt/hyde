require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

require_relative '../lib/parse_request'

class ParseRequestTest < Minitest::Test

  def test_parse_request_can_be_created
    submitted = ParseRequest.new('action', 'path', 'title')

    assert_kind_of ParseRequest, submitted
  end

  def test_parse_request_has_three_ivars
    submitted = ParseRequest.new('action', 'path', 'title')

    assert_equal 'action', submitted.action
    assert_equal 'path', submitted.path
    assert_equal 'title', submitted.title
  end

  def test_parse_submission_raises_arg_error_with_invalid_input
    assert_raises ArgumentError do
      ParseRequest.new('invalid', 'path', 'title').parse_submission
    end
  end


end
