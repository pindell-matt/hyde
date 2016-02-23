require 'pry'
require 'kramdown'

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
    Dir.glob(path + '/_output' + '/**/*.markdown') do |md_file|
      markdown_to_html(md_file)
    end
  end

  def markdown_to_html(file_path)
    markdown = File.read(file_path)
    html = Kramdown::Document.new(markdown).to_html
    File.open(file_path, 'w') { |file| file.write(html) }
    File.rename(file_path, file_path.split('.')[0] + '.html')
  end

  def build_post
    raise ArgumentError if title.nil?
    timestamp = timestamp_file(title.join('-').downcase + '.markdown')
    contents = "\##{title.join(" ")}\n\nYour content here"
    File.open(timestamp.last, 'w') { |file| file.write(contents) }
    puts "Created a new post file at #{timestamp.last}"
  end

end
