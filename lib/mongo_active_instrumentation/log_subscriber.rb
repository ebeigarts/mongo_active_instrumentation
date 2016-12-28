module MongoActiveInstrumentation
  class LogSubscriber < ActiveSupport::LogSubscriber
    def self.runtime=(value)
      Thread.current["mongo_runtime"] = value
    end

    def self.runtime
      Thread.current["mongo_runtime"] ||= 0
    end

    def self.reset_runtime
      rt, self.runtime = runtime, 0
      rt
    end

    def initialize(options = {})
      super()
      @events = {}
    end

    def started(event)
      return unless logger.debug?
      @events[event.request_id] = event
    end

    def succeeded(event)
      return unless logger.debug?
      completed event, CYAN
    end

    def failed(event)
      return unless logger.debug?
      completed event, RED
    end

    private

    def completed(event, name_color)
      started_event = @events.delete(event.request_id)
      if started_event
        duration = event.duration * 1000
        self.class.runtime += duration
        command_name = started_event.command_name.to_s
        name  = "Mongo (#{(duration).round(1)}ms)"
        name  = color(name, name_color, true)
        command = event.respond_to?(:message) ? event.message : started_event.command.inspect
        command = color(command, command_color(command_name), true)
        debug "  #{name}  #{command}"
      end
    end

    def command_color(command_name)
      case command_name
      when 'find', 'count', 'aggregate'
        BLUE
      when 'insert'
        GREEN
      when 'update'
        YELLOW
      when 'delete'
        RED
      else
        MAGENTA
      end
    end
  end
end
