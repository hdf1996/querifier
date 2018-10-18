RSpec.describe Dummy::Queries::BookWithFilter do
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

    # TODO: Until here, should be in a general shared context

    describe '.collection' do
      context 'with filter' do
        let(:query) { described_class.new(params) }
        subject(:collection) { query.collection }

        before do
          allow(query).to receive(:filter_by_key)
          allow(query).to receive(:filter_by_key_2)
          allow(query).to receive(:filter_by_non_enabled_key)
          collection
        end

        context 'with a simple filter key' do
          let(:params) { { filter: { where: { key: '1' } } } }

          it 'calls the filter_by_key statement with the correct params' do
            expect(query).to have_received(:filter_by_key).with('1')
          end
        end

        context 'with multiple valid filter key' do
          let(:params) { { filter: { where: { key: '1', key_2: '2'  } } } }

          it 'calls the filter_by_key statement with the key params' do
            expect(query).to have_received(:filter_by_key).with('1')
          end

          it 'calls the filter_by_key_2 statement with the second key params' do
            expect(query).to have_received(:filter_by_key_2).with('2')
          end
        end

        context 'with a non enabled filter key' do
          let(:params) { { filter: { where: { non_enabled_key: '1'} } } }

          it 'doesn\'t call the filter_by_non_enabled_key statement' do
            expect(query).not_to have_received(:filter_by_non_enabled_key)
          end
        end

        context 'with a empty enabled filter key' do
          let(:params) { { filter: { where: { key: ''} } } }

          it 'calls the filter_by_key statement with the key params' do
            expect(query).to have_received(:filter_by_key).with('')
          end
        end

        context 'with a nil enabled filter key' do
          let(:params) { { filter: { where: { key: nil} } } }

          it 'doesn\'t call the filter_by_non_enabled_key statement' do
            expect(query).not_to have_received(:filter_by_key)
          end
        end

        context 'with a non enabled filter key and a enabled key' do
          let(:params) { { filter: { where: { non_enabled_key: '1', key_2: '2'  } } } }

          it 'doesn\'t call the filter_by_non_enabled_key statement' do
            expect(query).not_to have_received(:filter_by_non_enabled_key)
          end

          it 'calls the filter_by_key_2 statement with the second key params' do
            expect(query).to have_received(:filter_by_key_2).with('2')
          end
        end

        context 'without a filter key' do
          let(:params) { { other_key: { where: { key: '1' } } } }

          it 'doesn\'t call the filter_by statement' do
            expect(query).not_to have_received(:filter_by_key)
          end
        end
      end
    end
  end
end
