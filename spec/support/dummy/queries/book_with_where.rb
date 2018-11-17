module Dummy
  module Queries
    class BookWithWhere
      include Querifier::Queries::Base
      include Querifier::Queries::Where


      WHERE_ATTRIBUTES = [:key, :key_2].freeze

      def default_collection
        ::Book.all
      end
    end
  end
end
