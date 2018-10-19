module Dummy
  module Queries
    class BookWithOrder
      include Querifier::Queries::Base
      include Querifier::Queries::Order

      ORDER_ATTRIBUTES = [:key, :key_2].freeze

      entity_class ::Book
    end
  end
end
