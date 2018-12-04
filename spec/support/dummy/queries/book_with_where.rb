module Dummy
  module Queries
    class BookWithWhere
      include Querifier::Queries::Base
      include Querifier::Queries::Where


      where_attributes :key, :key_2

      def default_collection
        ::Book.all
      end
    end
  end
end
