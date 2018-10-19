module Querifier
  module Generators
    class QueryGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)
      desc 'Creates Querifier query for your application'

      def create_service
        template 'query.rb.erb', "app/queries/#{plural_name.singularize}_query.rb"
      end
    end
  end
end
