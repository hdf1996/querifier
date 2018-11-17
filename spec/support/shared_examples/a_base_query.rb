shared_examples "a base query" do |default_collection|
  describe '.default_collection' do
    it 'responds with Book collection' do
      expect(described_class.default_collection).to eq(default_collection)
    end
  end

  describe '.new' do
    subject(:query) { described_class.new(params) }
    context 'with params' do
      let(:params) { { test: '1' } }

      it 'doesn\'t raise exceptions' do
        expect { query }.not_to raise_exception
      end
    end

    context 'with empty params' do
      let(:params) { {} }

      it 'doesn\'t raise exceptions' do
        expect { query }.not_to raise_exception
      end
    end

    context 'with nil params' do
      let(:params) { nil }

      it 'does raise an ArgumentError' do
        expect { query }.to raise_exception(ArgumentError)
      end
    end
  end

  describe '#filter_params' do
    subject(:params) { described_class.new(params).params }
    context 'with the filter key' do
      let(:params) { { filter: { where: { key: '1' } } } }

      it 'doesn\'t raise exceptions' do
        expect { params }.not_to raise_exception
      end
    end

    context 'without the filter key' do
      let(:params) { { other_key: { where: { key: '1' } } } }

      it 'doesn\'t raise exceptions' do
        expect { params }.not_to raise_exception
      end
    end
  end
end
