module Dummy
  module Queries
    class BookWithFilter
      include Apinator::Queries::Base
      include Apinator::Queries::Filter


      FILTER_ATTRIBUTES = [:key, :key_2].freeze

      entity_class ::Book
    end
  end
end
