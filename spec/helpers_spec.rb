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

  context '.colors' do
    it { expect(described_class.bg_red).to eq "\x1b[41m"}
    it { expect(described_class.bg_green).to eq "\x1b[42m"}
    it { expect(described_class.bg_yellow).to eq  "\x1b[43m"}
    it { expect(described_class.bg_white).to eq "\x1b[47m"}

    it { expect(described_class.red).to eq "\x1b[31m"}
    it { expect(described_class.green).to eq "\x1b[32m"}
    it { expect(described_class.yellow).to eq  "\x1b[33m"}
    it { expect(described_class.white).to eq "\x1b[37m"}
  end
end
