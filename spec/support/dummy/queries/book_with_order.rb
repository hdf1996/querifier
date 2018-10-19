module Dummy
  module Queries
    class BookWithOrder
      include Apinator::Queries::Base
      include Apinator::Queries::Order

      ORDER_ATTRIBUTES = [:key, :key_2].freeze

      entity_class ::Book
    end
  end
end
