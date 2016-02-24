require_relative 'hyde'
# require_relative 'event_watcher'
require 'listen'

class ParseRequest
  # include EventWatcher
  attr_reader :action, :path, :title

  def initialize(action, path, title)
    @action = action
    @path   = path
    @title  = title
  end

  def parse_submission
    hyde = Hyde.new(action, path, title)
    case action
    when 'new'
      hyde.build_new
    when 'build'
      hyde.build_output
    when 'post'
      hyde.build_post
    when 'watchfs'
      # watch(hyde, path)
      event_watcher(hyde)
    end
  end

  def event_watcher(hyde)
    listener = Listen.to(path) do |modified, added, removed|
      hyde.build_output
    end

    listener.start
    sleep
  end

end
