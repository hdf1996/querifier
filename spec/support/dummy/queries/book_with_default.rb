module Dummy
  module Queries
    class BookWithDefault
      include Querifier::Queries::Default

      ORDER_ATTRIBUTES = [:key, :key_2].freeze
      WHERE_ATTRIBUTES = [:key, :key_2].freeze

      entity_class ::Book
    end
  end
end
