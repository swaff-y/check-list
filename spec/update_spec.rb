# frozen_string_literal: true

require_relative '../lib/update'

RSpec.describe CheckList::Update do
  let(:update) { described_class }
  let(:json) { {
    'results' => [
      {
        'name' => 'checklist',
        'ref' => 'ca-123456',
        'tasks' => [
          {
            'name' => 'task name',
            'status' => 'y',
            'subTasks' => [
              {
                'name' => 'subtask name',
                'status' => 'n',
              }
            ]
          }
        ]
      },
      {
        'name' => 'checklist2',
        'ref' => 'ca-654321',
        'tasks' => [
          {
            'name' => 'task name',
            'status' => 'y',
            'subTasks' => [
              {
                'name' => 'subtask name',
                'status' => 'n',
              }
            ]
          }
        ]
      }
    ]
  } }
  let(:filepath) { instance_double(CheckList::HandleFile, :fetch_json => json) }

  before do 
    allow(CheckList::Helpers).to receive(:clear).and_return('clear')
    allow(CheckList::Helpers).to receive(:log).and_return('log')
    allow(CheckList::Helpers).to receive(:good_bye).and_return('good_bye')
    allow(CheckList::Helpers).to receive(:leave).and_return('leave')
    allow(CheckList::Helpers).to receive(:ret_value).and_return('1')
    allow(CheckList::Helpers).to receive(:green).and_return('')
    allow(CheckList::Helpers).to receive(:red).and_return('')
    allow(CheckList::Helpers).to receive(:yellow).and_return('')
    allow(CheckList::Helpers).to receive(:white).and_return('')
    allow(CheckList::Config).to receive(:time_now).and_return('')
    allow(CheckList::DisplayResults).to receive(:new).and_return('display_results')
    allow_any_instance_of(CheckList::HandleFile).to receive(:fetch_json).and_return(json)
  end

  context '.show_lists' do
    it 'shows the lists' do
      allow_any_instance_of(update).to receive(:show_list).and_return('shown_list')
      allow_any_instance_of(update).to receive(:validate_ret_value).and_return(1)
      expect(update.new('opts', filepath).show_lists('')).to eq 'shown_list'
    end

    it 'recovers from a bad input' do
      allow_any_instance_of(update).to receive(:show_list).and_return('shown_list')
      allow_any_instance_of(update).to receive(:validate_ret_value).and_return(0,1)
      expect(update.new('opts', filepath).show_lists('')).to eq 'shown_list'
    end
  end

  context '.validate_ret_value' do
    it 'gets a value from the user and returns it' do
      expect(update.new('opts', filepath).validate_ret_value('1', json['results'])).to eq 1
    end

    it 'gets the value q from the user and quits' do
      expect(update.new('opts', filepath).validate_ret_value('q', json['results'])).to eq 'good_bye'
    end

    it 'gets a non integer from the user and returns 0' do
      expect(update.new('opts', filepath).validate_ret_value('r', json['results'])).to eq 0
    end

    it 'raises and returns 0' do
      allow(CheckList::Helpers).to receive(:good_bye).and_raise StandardError, 'foo error'
      expect(update.new('opts', filepath).validate_ret_value('r', nil)).to eq 0
    end
  end

  context '.show_list' do
    it 'gets a value from the user and returns it' do
      allow_any_instance_of(update).to receive(:edit).and_return('edit')
      expect(update.new('opts', filepath).show_list(1, '')).to eq 'edit'
    end

    it 'gets a value from the user and returns it' do
      allow_any_instance_of(update).to receive(:edit).and_raise StandardError, 'foo error'
      expect(update.new('opts', filepath).show_list(1, '')).to eq 'leave'
    end
  end

  context '.edit' do
    it 'gets a value from the user and returns the task' do
      allow_any_instance_of(update).to receive(:show_list).and_return('show_list')
      expect(update.new('opts', filepath).edit('orig_value')).to eq 'show_list'
    end

    it 'gets a value from the user and subtask' do
      allow(CheckList::Helpers).to receive(:ret_value).and_return('1,1')
      allow_any_instance_of(update).to receive(:show_list).and_return('show_list')
      expect(update.new('opts', filepath).edit('orig_value')).to eq 'show_list'
    end

    it 'gets a value from the user and returns list' do
      allow(CheckList::Helpers).to receive(:ret_value).and_return('y')
      allow_any_instance_of(update).to receive(:show_list).and_return('show_list')
      expect(update.new('opts', filepath).edit('orig_value')).to eq 'show_list'
    end
  end
end