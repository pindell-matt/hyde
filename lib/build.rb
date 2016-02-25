require 'pry'
require 'kramdown'
require 'erb'
require 'sass'

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
    html = generate_html(markdown)
    File.open(file, 'w') { |file| file.write(html) }
    File.rename(file, file.split('.')[0] + '.html')
  end

  def generate_html(markdown)
    html = Kramdown::Document.new(markdown).to_html
    template = File.read(path + '/source/layouts/default.html.erb')
    ERB.new(template).result(binding)
  end

  def sass_to_css(file)
    sass = File.read(file)
    sass_engine = Sass::Engine.new(sass)
    File.open(file, 'w') { |file| file.write(sass_engine.render) }
    File.rename(file, file.split('.')[0] + '.css')
  end

end
