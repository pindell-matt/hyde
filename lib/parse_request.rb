# require_relative 'hyde'
# Load Path?
require_relative 'event_watcher'
require_relative 'generate_new'
require_relative 'build'
require_relative 'post'

class ParseRequest
  include EventWatcher
  attr_reader :action, :path, :title

  def initialize(action, path, title)
    @action = action
    @path   = path
    @title  = title
  end

  def parse_submission
    case action
    when 'new'
      GenerateNew.new(path).build_new
    when 'build'
      Build.new(path).build_output
    when 'post'
      Post.new(path, title).build_post
    when 'watchfs'
      watch(path)
    else
      puts "Please enter a valid action: new, build, post, or watchfs."
    end
  end

end
