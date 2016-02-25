require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

require_relative '../lib/post'
require_relative '../lib/generate_new'

class PostTest < Minitest::Test
  attr_reader :build_path, :test_path

  def setup
    @working_directory = Dir.pwd
    @build_path = File.expand_path(@working_directory + '/test/test_content/building')
    @test_path = File.expand_path(@working_directory + '/test/test_content/test_dir')
    FileUtils.rm_r(build_path) if File.exists? (build_path)
  end

  def test_post_can_build
    name = "Test"
    hyde = GenerateNew.new(build_path)
    hyde.build

    post = Post.new(build_path, [name]).build
    time = Time.new.strftime('%Y-%m-%d') + '-' + name

    assert File.exists? File.expand_path(build_path + "/source/posts/#{time}.markdown")
  end

end
