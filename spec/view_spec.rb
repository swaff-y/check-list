# frozen_string_literal: true

require_relative '../lib/view'

RSpec.describe CheckList::View do
  before do
    allow(CheckList::Helpers).to receive(:system_cmd).and_return('open')
  end

  it 'opens the browser with the index file' do
    expect(described_class.new.send(:open_browser_view)).to eq 'open'
  end
end