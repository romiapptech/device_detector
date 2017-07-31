require_relative '../spec_helper'

describe DeviceDetector::RegexCache do

  let(:subject) { DeviceDetector::RegexCache.new(config) }

  let(:config) { {} }

  describe '#set' do

    describe 'string key' do

      let(:key) { 'string' }

      it 'sets the value under the key' do
        subject.set(key, 'value')

        subject.data[key].must_equal 'value'
      end

    end

    describe 'array key' do

      let(:key) { ['string1', 'string2'] }

      it 'sets the value under the key' do
        subject.set(key, 'value')

        subject.data[String(key)].must_equal 'value'
      end

    end

  end

  describe '#get' do

    describe 'string key' do

      let(:key) { 'string' }

      it 'gets the value for the key' do
        subject.data[key] = 'value'

        subject.get(key).must_equal 'value'
      end

    end

    describe 'array key' do

      let(:key) { ['string1', 'string2'] }

      it 'gets the value for the key' do
        subject.data[String(key)] = 'value'

        subject.get(key).must_equal 'value'
      end

    end

  end

  describe '#get_or_set' do

    let(:key) { 'string' }

    describe 'value already present' do

      it 'gets the value for the key from cache' do
        subject.data[key] = 'value'

        block_called = false
        value = subject.get_or_set(key) do
          block_called = true
        end

        value.must_equal 'value'
        block_called.must_equal false
      end

    end

    describe 'value not yet present' do

      it 'evaluates the block and sets the result' do
        block_called = false
        subject.get_or_set(key) do
          block_called = true
        end

        block_called.must_equal true
        subject.data[key].must_equal true
      end

    end

  end

end
