# frozen_string_literal: true

require_relative '../lib/validations'

RSpec.describe CheckList::Validations do
  let(:validation) { described_class }
  let(:array) { ['one', 'two'] }

  context '.validate' do
    it 'value q' do
      expect(validation.validate('q', array)).to eq 0
    end
  end
end