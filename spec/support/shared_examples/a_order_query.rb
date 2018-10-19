shared_examples "a order query" do
  describe "#sort_by" do
    let(:query) { described_class.new(params) }

    before do
      allow(described_class.entity_class).to receive(:order)
      query.collection
    end

    context 'with an empty filter' do
      let(:params) { { filter: { order: { key: nil } } } }

      it 'orders by default' do
        expect(query.collection).to have_received(:order).with(described_class::DEFAULT_SORT)
      end
    end

    context 'with a fulfilled filter' do
      let(:params) { { filter: { order: { key: :desc } } } }

      it 'calls the order statement' do
        expect(query.collection).to have_received(:order).with(key: :desc)
      end
    end
  end

  described_class::ORDER_ATTRIBUTES.each do |attr|
    describe "#order_by_#{attr}" do
      let(:query) { described_class.new(params) }
      let(:params) { { filter: { order: { key: :desc } } } }
      subject(:order_by) { query.send("order_by_#{attr}") }

      before do
        allow(query).to receive(:order_by)
        order_by
      end

      it 'calls order_by' do
        expect(query).to have_received(:order_by).with(attr)
      end
    end
  end

  describe '#collection' do
    context 'with order' do
      let(:query) { described_class.new(params) }
      subject(:collection) { query.collection }

      before do
        allow(query).to receive(:order_by_key)
        allow(query).to receive(:order_by_key_2)
        allow(query).to receive(:order_by_non_enabled_key)
        allow(query).to receive(:order_by_default)
        collection
      end

      context 'with a simple filter key' do
        let(:params) { { filter: { order: { key: :desc } } } }

        it 'calls the order_by_key statement with the correct params' do
          expect(query).to have_received(:order_by_key).with(:desc)
        end
      end

      context 'with multiple valid filter key' do
        let(:params) { { filter: { order: { key: :desc, key_2: :asc  } } } }

        it 'calls the order_by_key statement with the key params' do
          expect(query).to have_received(:order_by_key).with(:desc)
        end

        # TODO: Change this when multiple sort is available
        it 'doesn\'t call the order_by_key_2 statement' do
          expect(query).not_to have_received(:order_by_key_2)
        end
      end

      context 'with a non enabled filter key' do
        let(:params) { { filter: { order: { non_enabled_key: :asc} } } }

        it 'doesn\'t call the order_by_non_enabled_key statement' do
          expect(query).not_to have_received(:order_by_non_enabled_key)
        end
      end

      context 'with a empty enabled filter key' do
        let(:params) { { filter: { order: { key: ''} } } }

        it 'doesn\'t call the order_by_key statement' do
          expect(query).not_to have_received(:order_by_key)
        end
      end

      context 'with an invalid enabled filter key' do
        let(:params) { { filter: { order: { key: :non_desc} } } }

        it 'doesn\'t call the order_by_key statement' do
          expect(query).not_to have_received(:order_by_key)
        end
      end

      context 'with a nil enabled filter key' do
        let(:params) { { filter: { order: { key: nil} } } }

        it 'doesn\'t call the order_by_non_enabled_key statement' do
          expect(query).not_to have_received(:order_by_key)
        end
      end

      context 'with a non enabled filter key and a enabled key' do
        let(:params) { { filter: { order: { non_enabled_key: :desc, key_2: :asc  } } } }

        it 'doesn\'t call the order_by_non_enabled_key statement' do
          expect(query).not_to have_received(:order_by_non_enabled_key)
        end

        it 'calls the order_by_key_2 statement with the second key params' do
          expect(query).to have_received(:order_by_key_2).with(:asc)
        end
      end

      context 'without a filter key' do
        let(:params) { { other_key: { order: { key: :desc } } } }

        it 'orders by default' do
          expect(query).to have_received(:order_by_default)
        end
      end
    end
  end
end
