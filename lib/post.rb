require_relative 'timestamp'
require 'pry'

class Post
  include Timestamp
  attr_reader :path, :title

  def initialize(path, title)
    @path   = path
    @title  = title
  end

  def build
    raise ArgumentError, 'Please enter a title for your post.' if title.nil?
    timestamp = timestamp_file(title.join('-').downcase + '.markdown', path)
    contents = "\##{title.join(" ")}\n\nYour content here"
    add_timestamp_to_file(timestamp, contents)
  end

  def add_timestamp_to_file(timestamp, contents)
    File.open(timestamp.last, 'w') { |file| file.write(contents) }
    puts "Created a new post file at #{timestamp.last}"
  end

end
