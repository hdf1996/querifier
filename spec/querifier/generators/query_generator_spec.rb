require 'generator_spec'
require 'generators/querifier/query_generator'

describe Querifier::Generators::QueryGenerator, type: :generator do
  context 'generating a query with a name' do
    destination File.expand_path('../../../../tmp', __FILE__)
    arguments %w(book)

    before(:all) do
      prepare_destination
      run_generator
    end

    # rubocop:disable Style/BlockDelimiters
    it 'generates the correct structure for the service' do
      expect(destination_root).to(have_structure {
        no_file 'book_query.rb'
        directory 'app' do
          no_file 'book_query.rb'
          directory 'queries' do
            file 'book_query.rb' do
              contains 'class BookQuery'
              contains 'include Querifier::Queries::Default'
            end
          end
        end
      })
    end
    # rubocop:enable Style/BlockDelimiters
  end
end
