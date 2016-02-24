require 'listen'

module EventWatcher

  def watch(hyde, path)
    listener = Listen.to(path) do |modified, added, removed|
      hyde.build_output
    end

    listener.start
    sleep
  end

end
