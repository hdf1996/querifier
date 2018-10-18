RSpec.describe Apinator::Queries::Base do
  context 'without overriding methods' do
    let(:base_query) do
      Class.new do
        include described_class
      end
    end
  end
end
