if defined? Rails
  require 'careful_parameter_logging/middleware'
  require 'careful_parameter_logging/controller'
  require 'careful_parameter_logging/railtie'
  require 'careful_parameter_logging/filter_parameters'
end
