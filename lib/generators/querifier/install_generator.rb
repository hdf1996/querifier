module Querifier
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      desc 'Creates Querifier initializer for your application'

      def copy_initializer
        template 'querifier.rb', 'config/initializers/querifier.rb'
      end
    end
  end
end
