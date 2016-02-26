require 'pry'
require 'kramdown'
require 'erb'
require 'sass'
require 'pathname'
require 'haml'

class Build
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def build
    FileUtils.cp_r(path + '/source/.', path + '/_output')
    file_converter
  end

  def file_converter
    Dir.glob(path + "/_output" + "/**/*.*") do |file|
      filetype = file.split(".")[1]
      markdown_to_html(file) if filetype == "markdown"
      sass_to_css(file) if filetype == "sass"
      haml_to_html(file) if filetype == "haml"
    end
  end

  def markdown_to_html(file)
    markdown = File.read(file)
    markdown, frontmatter = pull_yaml_frontmatter(markdown)
    html = generate_html(markdown, file, frontmatter)
    File.open(file, 'w') { |file| file.write(html) }
    File.rename(file, file.split('.')[0] + '.html')
  end

  def generate_html(markdown, file, frontmatter)
    css_paths = relative_path_to_css(file)
    html = Kramdown::Document.new(markdown).to_html
    template = File.read(path + '/source/layouts/default.html.erb')
    ERB.new(template).result(binding)
  end

  def pull_yaml_frontmatter(markdown)
    unless markdown.empty?
      markdown_array = markdown.split("---")
      if markdown_array[1]
        new_variables = markdown_array[1]
        markdown = markdown_array.last
      end
    end

    hash = {}
    unless new_variables.nil?
      new_variables.strip!
      var = new_variables.split("\n")
      var.each do |pair|
        element = pair.split(":")
        hash[element[0].strip.to_sym] = element[1].strip
      end
    end
    [markdown, hash]
  end

  def relative_path_to_css(submitted)
    path_to_submitted = Pathname.new(submitted)
    find_relative_paths(find_all_css, path_to_submitted)
  end

  def find_all_css
    css_array = []
    Dir.glob(path + "/_output" + "/**/*.css") do |file|
      css_array << file
    end
    css_array
  end

  def find_relative_paths(files_array, path_to_submitted)
    full_paths = files_array.map { |file| Pathname.new(file) }
    relative_paths = full_paths.map do |full_path|
      full_path.relative_path_from(path_to_submitted).to_s[1..-1]
    end
  end

  def sass_to_css(file)
    sass = File.read(file)
    sass_engine = Sass::Engine.new(sass)
    File.open(file, 'w') { |file| file.write(sass_engine.render) }
    File.rename(file, file.split('.')[0] + '.css')
  end

  def haml_to_html(file)
    haml = File.read(file)
    haml_engine = Haml::Engine.new(haml)
    output = haml_engine.render
    File.open(file, 'w') { |file| file.write(output) }
    File.rename(file, file.split('.')[0] + '.html')
  end

end
