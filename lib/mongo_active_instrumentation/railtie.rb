require 'mongo_active_instrumentation/controller_runtime'

module MongoActiveInstrumentation
  class Railtie < Rails::Railtie
    initializer "mongo_active_instrumentation" do |app|
      Mongo::Monitoring::Global.subscribe(
        Mongo::Monitoring::COMMAND,
        MongoActiveInstrumentation::LogSubscriber.new
      )

      # Disable the existing log subscriber
      Mongo::Monitoring::CommandLogSubscriber.class_eval do
        def started(event); end
        def succeeded(event); end
        def failed(event); end
      end

      ActiveSupport.on_load(:action_controller) do
        include MongoActiveInstrumentation::ControllerRuntime
      end
    end
  end
end
