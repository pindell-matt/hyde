require 'listen'

module EventWatcher

  def watch(path)
    listener = Listen.to(path) do |modified, added, removed|
      Build.new(path).build
    end

    listener.start
    sleep
  end

end
