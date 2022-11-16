# frozen_string_literal: true

require_relative '../lib/method'

RSpec.describe SpecRefLib::Method do
  let(:meth) { described_class }
  let(:filepath) { instance_double(SpecRefLib::HandleFile, fetch_json: { 'categories' => [ { 'name' => 'Tom', 'categories' => [{ 'name' => 'mouse', 'keywords' => ['one','two']}] } ]}) }

  context '.new' do
    before do
      allow(SpecRefLib::Helpers).to receive(:clear).and_return('clear')
      allow_any_instance_of(meth).to receive(:show_method).and_return('show_method')
    end

    it 'intializes correctly' do
      expect { meth.new(filepath, 'method') }.not_to raise_error
    end
  end

  context '.show_method' do
    before do
      allow(SpecRefLib::Helpers).to receive(:clear).and_return('clear')
      allow(SpecRefLib::Helpers).to receive(:log).and_return('logger')
      allow(SpecRefLib::Helpers).to receive(:ret_value).and_return('gets')
      allow_any_instance_of(meth).to receive(:handle_input).and_return('handle_input')
    end

    it 'shows the example' do
      m = meth.new(filepath, 'method')
      expect(m.show_method('one')).to eq 'handle_input'
    end
  end

  context '.handle_input' do
    before do
      allow(SpecRefLib::Helpers).to receive(:clear).and_return('clear')
      allow(SpecRefLib::Helpers).to receive(:log).and_return('logger')
      allow(SpecRefLib::Helpers).to receive(:leave).and_return('leave')
      allow(SpecRefLib::Start).to receive(:new).and_return('new_start')
      allow_any_instance_of(meth).to receive(:show_method).and_return('show_method')
    end

    it 'quits if q' do
      m = meth.new(filepath, 'method')
      expect(m.handle_input('q')).to eq 'leave'
    end

    it 'calls menu if not q' do
      m = meth.new(filepath, 'method')
      expect(m.handle_input('')).to eq 'new_start'
    end
  end
end
