# frozen_string_literal: true

require_relative '../lib/display_results'

RSpec.describe CheckList::DisplayResults do
  let(:results) { {
    :name => 'A checklist',
    :ref => 'reference',
    :tasks => [{
      :name => 'A task',
      :status => 'y',
      :time => '2022-01-01 00:00',
      :subTasks => [
        {
          :status => 'n',
          :name => 'A subtask',
          :time => '2022-01-01 00:00'
        },
        {
          :status => 'na',
          :name => 'Another subtask',
          :time => '2022-01-01 00:00'
        }
      ]
    }]
  } }

  before do
    allow(CheckList::Helpers).to receive(:clear).and_return('clear')
    allow(CheckList::Helpers).to receive(:log).and_return('log')
    allow(CheckList::Helpers).to receive(:green).and_return('')
    allow(CheckList::Helpers).to receive(:red).and_return('')
    allow(CheckList::Helpers).to receive(:yellow).and_return('')
    allow(CheckList::Helpers).to receive(:white).and_return('')
  end

  it { expect(described_class.new(results).send(:display_results) ).to eq 'log'}
end