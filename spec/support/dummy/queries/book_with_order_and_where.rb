module Dummy
  module Queries
    class BookWithOrderAndWhere
      include Querifier::Queries::Base
      include Querifier::Queries::Order
      include Querifier::Queries::Where

      ORDER_ATTRIBUTES = [:key, :key_2].freeze
      WHERE_ATTRIBUTES = [:key, :key_2].freeze

     def default_collection
       ::Book.all
     end
    end
  end
end
