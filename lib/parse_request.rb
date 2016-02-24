require_relative 'hyde'
require_relative 'event_watcher'

class ParseRequest
  include EventWatcher
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
      watch(hyde, path)
    end
  end

end

if __FILE__ == $0

  ParseRequest.new('watchfs', File.expand_path(Dir.pwd + '../test/test-support'), ["Initial", "Post"]).parse_submission

end
