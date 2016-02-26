require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

require_relative '../lib/generate_new'
require_relative '../lib/build'

class BuildTest < Minitest::Test
  attr_reader :build_path, :test_path

  def setup
    @working_directory = Dir.pwd
    @build_path = File.expand_path(@working_directory + '/test/test_content/building')
    @test_path = File.expand_path(@working_directory + '/test/test_content/test_dir')
    FileUtils.rm_r(build_path) if File.exists? (build_path)
  end

  def test_build_can_be_initialized
    built = Build.new(build_path)

    assert_kind_of Build, built
  end

  def test_build_has_a_path_ivar
    built = Build.new(build_path)

    assert_equal build_path, built.path
  end

  def test_build_can_find_all_css
    new_hyde = GenerateNew.new(build_path).build
    built    = Build.new(build_path)
    built.build

    submitted = built.find_all_css.count
    expected  = 2

    assert_equal expected, submitted
  end

  def test_build_finds_relative_path_to_css
    new_hyde = GenerateNew.new(build_path).build
    built    = Build.new(build_path)
    built.build

    submitted = built.relative_path_to_css(build_path + '/index.html')
    expected  = ["./_output/css/main.css", "./_output/css/test.css"]

    assert_equal expected, submitted
    assert_kind_of Array, submitted
  end

  def test_build_generates_html
    new_hyde = GenerateNew.new(build_path).build
    built    = Build.new(build_path)
    path     = test_path + '/placeholder.md'
    markdown = File.read(path)

    submitted = built.generate_html(markdown, path, {})
    expected  = "<html>\n  <head>\n    \n
    <title>Our Site</title>\n  </head>\n  <body>\n
    <h1 id=\"so-git-acknowledges-folder\">So Git Acknowledges Folder!</h1>
    \n\n  </body>\n</html>\n"

    assert_equal expected.scan(/\S/).join, submitted.scan(/\S/).join
  end

  def test_builds_output
    new_hyde = GenerateNew.new(build_path).build
    built    = Build.new(build_path)
    built.build

    assert File.exists? File.expand_path(build_path + '/_output/css/main.css')
    assert File.exists? File.expand_path(build_path + '/_output/css/test.css')
    assert File.exists? File.expand_path(build_path + '/_output/index.html')
    assert File.exists? File.expand_path(build_path + '/_output/layouts/default.html.erb')
    assert File.exists? File.expand_path(build_path + '/_output/pages/about.html')
  end

end
