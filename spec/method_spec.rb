# frozen_string_literal: true

require_relative '../lib/method'

RSpec.describe SpecRefLib::Method do
  let(:meth) { described_class }
  let(:filepath) { instance_double(SpecRefLib::HandleFile, fetch_json: { 'categories' => [ { 'name' => 'Tom' } ]}) }

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
    end

    it 'intializes correctly' do
      m = meth.new(filepath, 'method')
      expect(m.show_method).to eq 'logger'
    end
  end
end
