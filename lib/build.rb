require 'pry'
require 'kramdown'
require 'erb'
require 'sass'
require 'pathname'

class Build
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def build_output
    FileUtils.cp_r(path + '/source/.', path + '/_output')
    file_converter
  end

  def file_converter
    Dir.glob(path + "/_output" + "/**/*.*") do |file|
      filetype = file.split(".")[1]
      markdown_to_html(file) if filetype == "markdown"
      sass_to_css(file) if filetype == "sass"
    end
  end

  def markdown_to_html(file)
    markdown = File.read(file)
    html = generate_html(markdown, file)
    File.open(file, 'w') { |file| file.write(html) }
    File.rename(file, file.split('.')[0] + '.html')
  end

  def generate_html(markdown, file)
    path_to_css = relative_path_to_css(file)

    html = Kramdown::Document.new(markdown).to_html
    template = File.read(path + '/source/layouts/default.html.erb')
    ERB.new(template).result(binding)
  end

  def relative_path_to_css(submitted)
    path_to_css = ''
    Dir.glob(path + "/_output" + "/**/main.css") do |file|
      path_to_css += file
    end

    css = Pathname.new(path_to_css)
    path_to_submitted = Pathname.new(submitted)
    relative_path = css.relative_path_from(path_to_submitted).to_s
    array = relative_path.split("/")
    array.shift
    final = array.join("/")
    # puts final
  end

  def sass_to_css(file)
    sass = File.read(file)
    sass_engine = Sass::Engine.new(sass)
    File.open(file, 'w') { |file| file.write(sass_engine.render) }
    File.rename(file, file.split('.')[0] + '.css')
  end

end
