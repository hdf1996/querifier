require 'generator_spec'
require 'generators/querifier/install_generator'

describe Querifier::Generators::InstallGenerator, type: :generator do
  context 'generating the initializer ' do
    destination File.expand_path('../../../../tmp', __FILE__)

    before(:all) do
      prepare_destination
      run_generator
    end

    # rubocop:disable Style/BlockDelimiters
    it 'generates the correct structure for initializer' do
      expect(destination_root).to(have_structure {
        no_file 'querifier.rb'
        directory 'config' do
          no_file 'querifier.rb'
          directory 'initializers' do
            file 'querifier.rb' do
              contains 'Querifier.configure do'
            end
          end
        end
      })
    end
    # rubocop:enable Style/BlockDelimiters
  end
end
