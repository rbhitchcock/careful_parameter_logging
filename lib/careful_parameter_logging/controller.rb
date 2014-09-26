module CarefulParameterLogging
  module Controller
    extend ActiveSupport::Concern

    module ClassMethods
      def method_missing(meth, *args, &block)
        if meth.to_s =~ /^verify_(\w+)_parameter_for_(\w+)$/
          h = {model: $2.capitalize, parameter: $1}
          controller = self.name.gsub(/Controller/, '').downcase.to_sym
          Rails.application.config.careful_parameters[controller] << h
        else
          super
        end
      end

      def respond_to?(meth, include_private = false)
        if meth.to_s =~ /^verify_\w+_parameter_for_\w+$/
          true
        else
          super
        end
      end
    end
  end
end
