module Querifier
  module Queries
    module Base
      def initialize(params)
        @params = params
        check_params!
      end

      def collection
        @collection ||= self.class.default_collection
      end

      def params
        @params.fetch(Config.filter_param, {})
      end

      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        def default_collection
          @@default_collection ||= Object.const_get(self.name.split('::').last.split('Query').first).all
        end
      end

      private

      def check_params!
        return if @params.respond_to?(:keys) && @params.respond_to?(:has_key?)
        raise ArgumentError, "The params should extend of a hash, instead, they are a #{@params.class}" # rubocop:disable Metrics/LineLength
      end
    end
  end
end
