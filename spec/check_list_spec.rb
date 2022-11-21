# frozen_string_literal: true

require_relative '../lib/check_list'

RSpec.describe CheckList::Start do
  let(:start){ described_class }

  describe '.new' do
    before do
      allow(CheckList::HandleFile).to receive(:new).and_return('filepath')
      allow_any_instance_of(start).to receive(:set_options).and_return('options')
      allow_any_instance_of(start).to receive(:handler).and_return('handler')
    end

    it 'should initialize without error' do
      expect { start.new }.not_to raise_error
    end
  end

  describe '.set_options' do
    before do
      allow(CheckList::HandleFile).to receive(:new).and_return('new_file_handler')
      allow(Optimist).to receive(:options).and_return('options')
      allow_any_instance_of(start).to receive(:handler).and_return('handler')
    end

    it 'set options' do
      s = start.new
      expect { s.set_options }.not_to raise_error
    end
  end

  describe '.handler' do
    before do
      allow(CheckList::HandleFile).to receive(:new).and_return('new_file_handler')
      allow(CheckList::Menu).to receive(:new).and_return('new_menu')
      allow(CheckList::List).to receive(:new).and_return('new_list')
    end

    it 'handles a nil method selection' do
      allow_any_instance_of(start).to receive(:set_options).and_return({ :list => nil })
      s = start.new
      expect(s.handler).to eq 'new_menu'
    end

    it 'handles a not_nil method selection' do
      allow_any_instance_of(start).to receive(:set_options).and_return({ :list => 'not_nil' })
      s = start.new
      expect(s.handler).to eq 'new_list'
    end
  end
end