# frozen_string_literal: true

require_relative '../lib/list'

RSpec.describe CheckList::List do
  let(:list) { described_class }
  let(:filelist) { double('filelist', fetch_json: 'fetch_json' )}

  before do
    allow(CheckList::Helpers).to receive(:new).and_return('clear')
  end

  context '.new' do
    before do
      allow_any_instance_of(list).to receive(:show_list).and_return('show_list')
    end

    it { expect { list.new(filelist) }.not_to raise_error }
  end

  context '.show_list' do
    it 'logs list' do
      allow(CheckList::Helpers).to receive(:log).and_return('log')
      allow(CheckList::Helpers).to receive(:clear).and_return('clear')
      l = list.new(filelist)
      expect(l.show_list).to eq 'log'
    end
  end
end