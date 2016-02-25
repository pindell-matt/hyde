require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

require_relative '../lib/generate_new'
require_relative '../lib/build'

class BuildTest < Minitest::Test
  attr_reader :file_path

  def setup
    @working_directory = Dir.pwd
    @file_path = File.expand_path(@working_directory + '/test/test_content/building')
    FileUtils.rm_r(file_path) if File.exists? (file_path)
  end

  def test_build_can_be_initialized
    built = Build.new(file_path)

    assert_kind_of Build, built
  end

  def test_build_has_a_path_ivar
    built = Build.new(file_path)

    assert_equal file_path, built.path
  end

  def test_build_can_find_all_css
    new_hyde = GenerateNew.new(file_path).build_new
    built    = Build.new(file_path)
    built.build_output

    submitted = built.find_all_css.count
    expected  = 2

    assert_equal expected, submitted
  end

  def test_build_finds_relative_path_to_css
    new_hyde = GenerateNew.new(file_path).build_new
    built    = Build.new(file_path)
    built.build_output

    submitted = built.relative_path_to_css(file_path + '/index.html')
    expected  = ["./_output/css/main.css", "./_output/css/test.css"]

    assert_equal expected, submitted
    assert_kind_of Array, submitted
  end

  # def test_clone_can_duplicate_directory
  #   gen = GenerateNew.new(file_path)
  #   gen.clone(file_path + "/test_dir", file_path + '/success')
  #
  #   assert File.exists?(file_path + '/success')
  #   FileUtils.rm_r(file_path + '/success') if File.exists? (file_path + '/success')
  # end
  #
  # def test_can_confirm_directory_exists
  #   gen = GenerateNew.new(file_path)
  #   assert gen.check_path(file_path)
  # end
  #
  # def test_raises_arg_error_if_directory_already_exists
  #   assert_raises ArgumentError do
  #     GenerateNew.new(file_path).build_new
  #   end
  # end

end
