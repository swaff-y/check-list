# frozen_string_literal: true

require_relative '../lib/config'

RSpec.describe CheckList::Config do
  let(:config) { described_class }
  let(:time) { double('the time', year: 2022, month: 11, day: 22, hour: 14, min: 15  )}

  it { expect(config.version).to eq '0.0.0' }
  it { expect(config.default_url).to eq 'https://raw.githubusercontent.com/swaff-y/check-list/main/lib/checklist.json' }
  it { expect(config.env).to eq 'CHECK_LIST' }
  it { expect(config.coverage).to eq 80 }

  it 'gets the current time' do
    allow(Time).to receive(:now).and_return(time)
    expect(config.time_now).to eq '2022-11-22 14:15'
  end
end
