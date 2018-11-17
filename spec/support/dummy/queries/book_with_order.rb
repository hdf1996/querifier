module Dummy
  module Queries
    class BookWithOrder
      include Querifier::Queries::Base
      include Querifier::Queries::Order

      ORDER_ATTRIBUTES = [:key, :key_2].freeze

      def default_collection
        ::Book.all
      end
    end
  end
end
