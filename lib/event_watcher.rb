require 'listen'

module EventWatcher

  def watch(path)
    listener = Listen.to(path) do |modified, added, removed|
      Build.new(path).build_output
    end

    listener.start
    sleep
  end

end
