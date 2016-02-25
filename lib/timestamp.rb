require 'pry'

module Timestamp

  def timestamp_file(original, path)
    file_path   = path + '/source/posts/'
    orig_name   = file_path + original
    timestamped = file_path + Time.new.strftime('%Y-%m-%d') + '-' + original
    [orig_name, timestamped]
  end

end
