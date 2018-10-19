module Apinator
  module Queries
    module Default
      def self.included(klass)
        klass.send :include, Base
        klass.send :include, Order
        klass.send :include, Where
      end
    end
  end
end
