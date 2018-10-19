describe Dummy::Queries::BookWithDefault do
  it_behaves_like 'a base query', Book
  it_behaves_like 'a where query'
  it_behaves_like 'a order query'

  describe '#collection' do
    context 'with order and where' do
      let(:query) { described_class.new(params) }
      subject(:collection) { query.collection }

      before do
        allow(query).to receive(:order_by_key)
        allow(query).to receive(:filter_by_key)
        collection
      end

      context 'with a simple filter and order key' do
        let(:params) { { filter: { where: { key: '1' }, order: { key: :desc } } } }

        it 'calls the order_by_key statement with the correct params' do
          expect(query).to have_received(:order_by_key).with(:desc)
        end

        it 'calls the filter_by_key statement with the correct params' do
          expect(query).to have_received(:filter_by_key).with('1')
        end
      end
    end
  end
end
