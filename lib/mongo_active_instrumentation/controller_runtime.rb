require "active_support/core_ext/module/attr_internal"

module MongoActiveInstrumentation
  module ControllerRuntime #:nodoc:
    extend ActiveSupport::Concern

    protected

    attr_internal :mongo_runtime

    private

    def process_action(action, *args)
      # We also need to reset the runtime before each action
      # because of queries in middleware or in cases we are streaming
      # and it won't be cleaned up by the method below.
      MongoActiveInstrumentation::LogSubscriber.reset_runtime
      super
    end

    def cleanup_view_runtime
      if logger && logger.info?
        mongo_rt_before_render = MongoActiveInstrumentation::LogSubscriber.reset_runtime
        self.mongo_runtime = (mongo_runtime || 0) + mongo_rt_before_render
        runtime = super
        mongo_rt_after_render = MongoActiveInstrumentation::LogSubscriber.reset_runtime
        self.mongo_runtime += mongo_rt_after_render
        runtime - mongo_rt_after_render
      else
        super
      end
    end

    def append_info_to_payload(payload)
      super
      payload[:mongo_runtime] = (mongo_runtime || 0) + MongoActiveInstrumentation::LogSubscriber.reset_runtime
    end

    module ClassMethods # :nodoc:
      def log_process_action(payload)
        messages, mongo_runtime = super, payload[:mongo_runtime]
        messages << ("Mongo: %.1fms" % mongo_runtime.to_f) if mongo_runtime
        messages
      end
    end
  end
end
