require 'pry'
require 'kramdown'
require 'erb'
require 'sass'

class Hyde
  attr_reader :action, :path, :title

  def initialize(action, path, title = nil)
    @action = action
    @path   = path
    @title  = title
  end

  def clone(source, destination)
    FileUtils.cp_r(source, destination)
  end

  def check_path(path)
    Dir.exist?(path)
  end

  def build_new
    raise ArgumentError if check_path(path)
    clone('bin/template/.', path)
    orig_welcome, timestamped_welcome = timestamp_file('welcome-to-hyde.markdown')
    File.rename(orig_welcome, timestamped_welcome)
  end

  def timestamp_file(original)
    file_path   = path + '/source/posts/'
    orig_name   = file_path + original
    timestamped = file_path + Time.new.strftime('%Y-%m-%d') + '-' + original
    [orig_name, timestamped]
  end

  def build_output
    FileUtils.cp_r(path + '/source/.', path + '/_output')
    find_and_convert_markdown
    find_and_convert_sass
  end

  def find_and_convert_markdown
    Dir.glob(path + '/_output' + '/**/*.markdown') do |md_file|
      markdown_to_html(md_file)
    end
  end

  def find_and_convert_sass
    Dir.glob(path + '/_output' + '/**/*.sass') do |sass_file|
      sass_to_css(sass_file)
    end
  end

  def markdown_to_html(file)
    markdown = File.read(file)
    formatted_html = default_html_format(markdown)
    File.open(file, 'w') { |file| file.write(formatted_html) }
    File.rename(file, file.split('.')[0] + '.html')
  end

  def sass_to_css(file)
    sass = File.read(file)
    sass_engine = Sass::Engine.new(sass)

    File.open(file, 'w') { |file| file.write(sass_engine.render) }
    File.rename(file, file.split('.')[0] + '.css')
  end

  def default_html_format(markdown)
    html = Kramdown::Document.new(markdown).to_html
    template = File.read(path + '/source/layouts/default.html.erb')
    ERB.new(template).result(binding)
  end

  def build_post
    raise ArgumentError if title.nil?
    timestamp = timestamp_file(title.join('-').downcase + '.markdown')
    contents = "\##{title.join(" ")}\n\nYour content here"
    File.open(timestamp.last, 'w') { |file| file.write(contents) }
    puts "Created a new post file at #{timestamp.last}"
  end

end
