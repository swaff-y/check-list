# frozen_string_literal: true

require_relative '../lib/helpers'

RSpec.describe SpecRefLib::Helpers do
  context '.log' do
    xit 'logs the correct value' do
      m = menu.new
      expect { m.log('value') }.to output("value\n").to_stdout
    end
  end

  context '.leave' do
    xit 'exits' do
      m = menu.new
      expect { m.leave }.to raise_error SystemExit
    end
  end

  context '.ret_value' do
    xit 'gets the correct value' do
      allow($stdin).to receive(:gets).and_return('foo')
      m = menu.new
      expect(m.ret_value).to eq 'foo'
    end
  end
end
