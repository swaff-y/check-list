# frozen_string_literal: true

require_relative '../lib/handle_file'

RSpec.describe SpecRefLib::HandleFile do
  xit 'exits if env variable is not set' do
    stub_const('SpecRefLib::Menu::FILEPATH', nil)
    m = menu.new
    expect(m.status).to eq 'no path set'
  end

  xit 'exits if filepath invalid' do
    stub_const('SpecRefLib::Menu::FILEPATH', 'invalid')
    allow(JSON).to receive(:parse).and_raise
    m = menu.new
    expect(m.status).to eq 'invalid path'
  end
end
