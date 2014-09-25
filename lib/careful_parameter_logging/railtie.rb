module CarefulParameterLogging
  class Railtie < Rails::Railtie
    config.careful_parameters = Hash.new do |h, k|
      h[k] = []
    end

    initializer "carefulparameterlogging.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include CarefulParameterLogging::Controller
      end
    end

    initializer "carefulparameterlogging.middleware" do |app|
      app.middleware.insert_before "::Rails::Rack::Logger", "CarefulParameterLogging::Middleware"
    end
  end
end
