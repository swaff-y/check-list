# frozen_string_literal: true

require_relative '../lib/validations'

RSpec.describe CheckList::Validations do
  let(:validation) { described_class }
  let(:array) { ['one', 'two'] }

  context '.validate' do
    it 'value q' do
      expect(validation.validate('q', array)).to eq 0
    end

    it 'value 1' do
      expect(validation.validate('1', array)).to eq 1
    end

    it 'No array' do
      expect(validation.validate('1', nil)).to eq false
    end

    it 'nil' do
      expect(validation.validate('5', array)).to eq nil
    end
  end

  context '.validate_response' do
      it { expect(validation.validate_response('y')).to eq 'y' }
      it { expect(validation.validate_response('n')).to eq 'n' }
      it { expect(validation.validate_response('na')).to eq 'na' }
      it { expect(validation.validate_response('q')).to eq 'q' }
      it { expect(validation.validate_response('d')).to eq 0 }
  end
end