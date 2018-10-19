module Dummy
  module Queries
    class BookWithWhere
      include Apinator::Queries::Base
      include Apinator::Queries::Where


      WHERE_ATTRIBUTES = [:key, :key_2].freeze

      entity_class ::Book
    end
  end
end
