require_relative 'timestamp'
require 'pry'

class GenerateNew
  include Timestamp
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def build_new
    raise ArgumentError, 'Directory already exists!' if check_path(path)
    clone('lib/template/.', path)
    orig_welcome, timestamped_welcome = timestamp_file('welcome-to-hyde.markdown', path)
    File.rename(orig_welcome, timestamped_welcome)
  end

  def clone(source, destination)
    FileUtils.cp_r(source, destination)
  end

  def check_path(path)
    Dir.exist?(path)
  end

end
