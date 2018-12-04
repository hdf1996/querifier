shared_examples "a order query" do
  describe '.default_sort' do
    let!(:old_default_sort) { described_class.default_sort.dup }
    let(:fake_attributes) { { Time.now.to_i.to_s.to_sym => true } }
    before do
      stub_const 'FakeOrderClass', Class.new
      FakeOrderClass.class_eval{ include Querifier::Queries::Order }
    end

    after(:each) { described_class.default_sort old_default_sort }

    it 'does not change if base class does' do
      expect { FakeOrderClass.default_sort fake_attributes }.not_to(
        change { described_class.default_sort }
      )
    end

    it 'does not change if base class does' do
      expect { described_class.default_sort *fake_attributes }.not_to(
        change { FakeOrderClass.order_attributes }
      )
    end
  end

  describe '.order_attributes' do
    let!(:old_order_attributes) { described_class.order_attributes.dup }
    let(:fake_attributes) { [Time.now.to_i.to_s.to_sym] }
    before do
      stub_const 'FakeOrderClass', Class.new
      FakeOrderClass.class_eval{ include Querifier::Queries::Order }
    end

    after(:each) { described_class.order_attributes *old_order_attributes }

    it 'does not change if base class does' do
      expect { FakeOrderClass.order_attributes *fake_attributes }.not_to(
        change { described_class.order_attributes }
      )
    end

    it 'does not change if base class does' do
      expect { described_class.order_attributes *fake_attributes }.not_to(
        change { FakeOrderClass.order_attributes }
      )
    end
  end

  describe "#sort_by" do
    let(:query) { described_class.new(params) }

    before do
      allow(described_class.default_collection).to receive(:order)
      query.collection
    end

    context 'with an empty filter' do
      let(:params) { { filter: { order: { key: nil } } } }

      it 'orders by default' do
        expect(query.collection).to have_received(:order).with(described_class.default_sort)
      end
    end

    context 'with a fulfilled filter' do
      let(:params) { { filter: { order: { key: :desc } } } }

      it 'calls the order statement' do
        expect(query.collection).to have_received(:order).with(key: :desc)
      end
    end
  end

  described_class.order_attributes.each do |attr|
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
