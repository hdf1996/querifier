RSpec.describe Dummy::Queries::Book do
  describe '.entity_class' do
    it 'responds with Book class' do
      expect(described_class.entity_class).to eq(Book)
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

    describe '#params' do
      subject(:params) { described_class.new(params).params }
      context 'with the filter key' do
        let(:params) { { filter: { where: { key: '1' } } } }

        it 'doesn\'t raise exceptions' do
          expect { params }.not_to raise_exception
        end

        it 'has the where key filled'
      end

      context 'without the filter key' do
        let(:params) { { other_key: { where: { key: '1' } } } }

        it 'doesn\'t raise exceptions' do
          expect { params }.not_to raise_exception
        end

        it 'has an empty where key'
      end
    end
  end
end
