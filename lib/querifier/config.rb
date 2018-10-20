module Querifier
  module Config
    DEFAULTS_CONFIGS = {
      where_param: :where,
      order_param: :order,
      filter_param: :filter
    }.freeze

    module_function

    DEFAULTS_CONFIGS.each do |key, value|
      define_method key do
        instance_variable_get("@#{key}") || instance_variable_set("@#{key}", value)
      end

      define_method "#{key}=" do |v|
        instance_variable_set("@#{key}", v)
      end
    end

    # This is mostly useful for the tests
    def reset!
      DEFAULTS_CONFIGS.each { |k, v| send("#{k}=", v) }
    end
  end
end
