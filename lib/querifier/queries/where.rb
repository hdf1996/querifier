module Querifier
  module Queries
    module Where
      def collection
        super
        filter
        @collection
      end

      def filter
        return self if @filtered
        filter_params.each do |(attribute, _)|
          value = filter_value(attribute)
          send("filter_by_#{attribute}", value) if value
        end
        @filtered = true
        self
      end

      def filter_value(key)
        filter_params.fetch(key.to_sym, nil)
      end

      def filter_by(name, value)
        filter_content = filter_value(name)
        @collection = @collection.where("#{name} LIKE ?", "%#{filter_content}%") if filter_content
        self
      end

      def method_missing(message, *args, &block)
        return filter_by(Regexp.last_match(1).to_sym, args.first) if message.to_s =~ /filter_by_(.*)/ # rubocop:disable Performance/RegexpMatch, Metrics/LineLength
        super
      end

      def valid_option?(option)
        self.class.where_attributes.include?(option.to_sym)
      end

      def filter_params
        @filter_params ||=
          params.fetch(Config.where_param, {}).select { |k| valid_option? k.to_sym }
      end


      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        @@where_attributes = []

        def where_attributes(*value)
          return @@where_attributes = [*value] if value.any?
          @@where_attributes
        end
      end
    end
  end
end
