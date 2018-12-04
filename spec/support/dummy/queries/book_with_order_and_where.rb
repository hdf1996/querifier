module Dummy
  module Queries
    class BookWithOrderAndWhere
      include Querifier::Queries::Base
      include Querifier::Queries::Order
      include Querifier::Queries::Where

      order_attributes :key, :key_2
      where_attributes :key, :key_2

     def default_collection
       ::Book.all
     end
    end
  end
end
