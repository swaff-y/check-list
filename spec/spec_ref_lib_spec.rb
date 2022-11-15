# frozen_string_literal: true

require_relative '../lib/spec_ref_lib'

RSpec.describe SpecRefLib::Start do
  let(:start) { described_class }

  context ".new" do
    before do
      allow(SpecRefLib::HandleFile).to receive(:new).and_return('new_file_handler')
      allow_any_instance_of(start).to receive(:set_options).and_return('options')
      allow_any_instance_of(start).to receive(:handler).and_return('handler')
    end
    it 'intializes correctly' do
      expect { start.new }.not_to raise_error
    end
  end

  context ".set_options" do
    before do
      allow(SpecRefLib::HandleFile).to receive(:new).and_return('new_file_handler')
      allow(Optimist).to receive(:options).and_return('options')
      allow_any_instance_of(start).to receive(:handler).and_return('handler')
    end
    it 'set options' do
      s = start.new
      expect { s.set_options }.not_to raise_error
    end
  end

  context ".handler" do
    before do
      allow(SpecRefLib::HandleFile).to receive(:new).and_return('new_file_handler')
      allow(SpecRefLib::Menu).to receive(:new).and_return('new_menu')
      allow(SpecRefLib::Method).to receive(:new).and_return('new_method')
    end

    it 'handles a nil method selection' do
      allow_any_instance_of(start).to receive(:set_options).and_return({ :method => nil })
      s = start.new
      expect(s.handler).to eq 'new_menu'
    end

    it 'handles a not_nil method selection' do
      allow_any_instance_of(start).to receive(:set_options).and_return({ :method => 'not_nil' })
      s = start.new
      expect(s.handler).to eq 'new_method'
    end
  end
end
