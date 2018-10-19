module Apinator
  module Queries
    module Order
      ORDER_ATTRIBUTES = [].freeze
      DEFAULT_SORT = { id: :asc }.freeze

      def collection
        super
        order
        @collection
      end

      def order
        return self if @ordered
        if order_params.any? && valid_sort?(order_params.first)
          option, direction = order_params.first
          send("order_by_#{option}", direction)
        else
          order_by_default
        end
        @ordered = true
        self
      end

      def order_by_default
        order_by(*self.class::DEFAULT_SORT.to_a.flatten)
      end

      def order_by(option, direction)
        @collection = @collection.order(option => direction)
      end

      def valid_sort?(sort)
        option, direction = sort
        option &&
          direction &&
          self.class::ORDER_ATTRIBUTES.include?(option) &&
          %w[asc desc].include?(direction.to_s.downcase)
      end

      def method_missing(message, *args, &block)
        return order_by(Regexp.last_match(1).to_sym, *args) if message.to_s =~ /order_by_(.*)/ # rubocop:disable Performance/RegexpMatch, Metrics/LineLength
        super
      end

      def order_params
        @order_params ||= params.fetch(:order, {}).find_all { |(k, _)| self.class::ORDER_ATTRIBUTES.include? k }.to_h #TODO: unhardcode order
      end
    end
  end
end
