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
    @error_message = "Enter a valid action: new, build, post, or watchfs."
  end

  def parse_map
    {'new' => GenerateNew, 'build' => Build, 'post' => Post}
  end

  def parse_submission
    watch(path) if action == 'watchfs'
    raise ArgumentError, @error_message unless parse_map.has_key?(action)
    if action == "post"
      parse_map[action].new(path, title).build
    else
      parse_map[action].new(path).build
    end
  end

end
