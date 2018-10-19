module Dummy
  module Queries
    class BookWithOrderAndWhere
      include Apinator::Queries::Base
      include Apinator::Queries::Order
      include Apinator::Queries::Where

      ORDER_ATTRIBUTES = [:key, :key_2].freeze
      WHERE_ATTRIBUTES = [:key, :key_2].freeze

      entity_class ::Book
    end
  end
end
