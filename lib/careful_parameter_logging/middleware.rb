require 'action_dispatch/http/parameter_filter'

module CarefulParameterLogging

  class Middleware
    FORM_HASH = 'rack.request.form_hash'.freeze
    QUERY_PARAMS = "QUERY_STRING".freeze
    PARAMETER_FILTER = "action_dispatch.parameter_filter".freeze
    REQUEST_PATH = "REQUEST_PATH".freeze

    def initialize(app)
      @app = app
      @careful_parameters = Rails.application.config.careful_parameters || {}
    end

    def call(env)
      begin
        controller = Rails.application.routes.recognize_path(env[REQUEST_PATH])[:controller]
      rescue ActionController::RoutingError
        controller = nil
      end
      if controller and !@careful_parameters[controller.to_sym].blank?
        params = env[FORM_HASH] || Rack::Utils.parse_nested_query(env[QUERY_PARAMS]) || {}
        env[PARAMETER_FILTER] += filter_params_without_records(controller.to_sym, params)
      end
      status, headers, response = @app.call(env)
    end

    private

      def filter_params_without_records(key, params)
        return [] if params.empty?
        @careful_parameters[key].map do |h|
          h[:parameter] if params_contain_sensitive_attr? h[:parameter], h[:model].constantize, params
        end.compact
      end

      def params_contain_sensitive_attr?(attr, model, params)
        traverse_hash = lambda do |params|
          params.any? do |k, v|
            if v.is_a? Hash
              traverse_hash.call v
            elsif attr.to_sym == k.to_sym and !model.where(attr.to_sym => v).first
              true
            end
          end
        end
        traverse_hash.call params
      end
  end
end
