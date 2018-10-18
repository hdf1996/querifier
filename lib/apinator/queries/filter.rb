module Apinator
  module Queries
    module Filter
      FILTER_ATTRIBUTES = [].freeze

      def collection
        super
        filter
        @collection
      end

      def filter
        self.class::FILTER_ATTRIBUTES.each do |attribute|
          filter_content = filter_value(attribute)
          send("filter_by_#{attribute}", filter_content) if filter_content
        end
        self
      end

      def filter_value(key)
        filter_params.fetch(key.to_sym, nil)
      end

      def filter_params
        @filter_params ||= params.fetch(:where, {}) #TODO: unhardcode where
      end
    end
  end
end
