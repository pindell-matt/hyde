require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

require_relative '../lib/generate_new'

class GenerateNewTest < Minitest::Test
  attr_reader :file_path

  def setup
    @working_directory = Dir.pwd
    @file_path = File.expand_path(@working_directory + '/test/test_content')
  end

  def test_generate_new_can_be_initialized
    gen = GenerateNew.new(file_path)

    assert_kind_of GenerateNew, gen
  end

  def test_generate_new_has_a_path_ivar
    gen = GenerateNew.new(file_path)

    assert_equal file_path, gen.path
  end

  def test_clone_can_duplicate_directory
    gen = GenerateNew.new(file_path)
    gen.clone(file_path + "/test_dir", file_path + '/success')

    assert File.exists?(file_path + '/success')
    FileUtils.rm_r(file_path + '/success') if File.exists? (file_path + '/success')
  end

  def test_can_confirm_directory_exists
    gen = GenerateNew.new(file_path)
    assert gen.check_path(file_path)
  end

  def test_raises_arg_error_if_directory_already_exists
    assert_raises ArgumentError do
      GenerateNew.new(file_path).build_new
    end
  end

end
