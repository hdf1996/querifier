module Dummy
  module Queries
    class BookWithOrder
      include Querifier::Queries::Base
      include Querifier::Queries::Order

      order_attributes :key, :key_2

      def default_collection
        ::Book.all
      end
    end
  end
end
