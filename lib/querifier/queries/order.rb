module Querifier
  module Queries
    module Order
      def collection
        super
        order
        @collection
      end

      def order
        return self if @ordered
        if valid_sort?
          # TODO: Permit multiple orders
          option = order_params.keys.first
          direction = order_params.fetch(option, nil)
          send("order_by_#{option}", direction)
        else
          order_by_default
        end
        @ordered = true
        self
      end

      def order_by_default
        order_by(*self.class.default_sort.to_a.flatten)
      end

      def order_by(option, direction)
        @collection = @collection.order(option => direction)
      end

      def valid_sort?
        option = order_params.keys.first
        direction = order_params.fetch(option, nil)
        option &&
          direction &&
          valid_option?(option) &&
          %w[asc desc].include?(direction.to_s.downcase)
      end

      def valid_option?(option)
        self.class.order_attributes.include?(option.to_sym)
      end

      def method_missing(message, *args, &block)
        return order_by(Regexp.last_match(1).to_sym, *args) if message.to_s =~ /order_by_(.*)/ # rubocop:disable Performance/RegexpMatch, Metrics/LineLength
        super
      end

      def order_params
        @order_params ||=
          params.fetch(Config.order_param, {}).select { |k| valid_option? k.to_sym }
      end

      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        @@order_attributes = []
        @@default_sort = { id: :asc }

        def order_attributes(*value)
          return @@order_attributes = [*value] if value.any?
          @@order_attributes
        end

        def default_sort(value = nil)
          return @@default_sort = value if value
          @@default_sort
        end
      end
    end
  end
end
