# frozen_string_literal: true

require_relative '../lib/helpers'

RSpec.describe CheckList::Helpers do
  let(:helper) { described_class }
  context '.log' do
    it 'logs the correct value' do
      expect { helper.log('value') }.to output("value\n").to_stdout
    end
  end

  context '.leave' do
    it 'exits' do
      expect { helper.leave }.to raise_error SystemExit
    end
  end

  context '.ret_value' do
    it 'gets the correct value' do
      allow($stdin).to receive(:gets).and_return('foo')
      expect(helper.ret_value).to eq 'foo'
    end
  end

  context '.system_cmd' do
      subject { described_class.system_cmd('ls') }
      before { allow(described_class).to receive(:`).and_return('test_dir') }
      it { is_expected.to eq('test_dir') } 
  end
end
