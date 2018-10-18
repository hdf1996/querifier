module Models
  class Base
    class << self
      def where(*args)
        self
      end
    end
  end
end
