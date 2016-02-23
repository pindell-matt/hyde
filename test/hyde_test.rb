# $LOAD_PATH.unshift(File.dirname(__FILE__))

lib_folder = File.expand_path(__dir__)
$LOAD_PATH << lib_folder

# require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'


class HydeTest < Minitest::Test

  def setup
    @file_path = File.expand_path('~/hyde-test')
    FileUtils.rm_r(@file_path) if File.exists? @file_path
  end

  def test_new_creates_directory
    submitted = `bin/hyde new #{@file_path}`

    assert File.exists? File.expand_path(@file_path)
  end

  def test_auto_delete_is_working
    refute File.exists? File.expand_path(@file_path)
  end

  def test_that_main_css_is_created
    submitted = `bin/hyde new #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/source/css/main.css')
  end

  def test_that_index_markdown_is_created
    submitted = `bin/hyde new #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/source/index.markdown')
  end

  def test_that_about_markdown_is_created
    submitted = `bin/hyde new #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/source/pages/about.markdown')
  end
  
  def test_that_initial_post_markdown_is_created_with_timestamp
    submitted = `bin/hyde new #{@file_path}`
    timestamp = Time.new.strftime('%Y-%m-%d') + '-'

    assert File.exists? File.expand_path(@file_path + '/source/posts/' + timestamp + 'welcome-to-hyde.markdown')
  end


  # def test_that_it_generates_a_timestamp
  #
  # end

  # assert source is .md
  # assert _output is .html
  # file exist?
  # check content matches?
  # post title matches .md and .html content

end
