$LOAD_PATH.unshift(File.dirname(__FILE__))
# require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'


class HydeTest < Minitest::Test

  def setup
    file_path = File.expand_path('~/hyde-test')
    FileUtils.rm_r(file_path) if File.exists? file_path
  end

  def test_new_creates_directory
    file_path = '~/hyde-test'
    submitted = `bin/hyde new #{file_path}`

    assert File.exists? File.expand_path(file_path)
  end

  def test_auto_delete_is_working
    file_path = '~/hyde-test'
    refute File.exists? File.expand_path(file_path)
  end

  # assert source is .md
  # assert _output is .html
  # file exist?
  # check content matches?
  # post title matches .md and .html content

end
