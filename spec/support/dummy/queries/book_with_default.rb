module Dummy
  module Queries
    class BookWithDefault
      include Querifier::Queries::Default

      order_attributes :key, :key_2
      where_attributes :key, :key_2

      def default_collection
        ::Book.all
      end
    end
  end
end
