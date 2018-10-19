module Models
  class Base
    class << self
      def all
        self
      end

      def where(*args)
        self
      end

      def order(*args)
        self
      end
    end
  end
end
