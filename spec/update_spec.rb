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
  let(:list) { { 
    'tasks' => [ 
      { 
        'name' => 'name', 
        'subTasks' => [ 
          { 
            'name' => 'name', 
            'status' => 'y' 
          } 
        ] 
      } 
    ] 
  } }
  let(:sym) {
    double('sym', hash: 'A hash')
  }

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
    allow(CheckList::Helpers).to receive(:check_status).and_return('check_status')
    allow(CheckList::Helpers).to receive(:write_json_file).and_return('write_file')
    allow(Sym).to receive(:new).and_return('write_file')
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

  context '.show_sub_tasks' do
    it 'shows sub tasks' do
      allow_any_instance_of(update).to receive(:edit_sub_task).and_return('edit_sub_task')
      allow_any_instance_of(update).to receive(:show_list).and_return('show_list')
      s = update.new('opts', filepath)
      s.instance_variable_set(:@list, list)
      expect(s.show_sub_tasks(1, 'orig_value')).to eq 'edit_sub_task'
    end
  end

  context '.edit_sub_task' do
    it 'edits a sub task' do
      allow_any_instance_of(update).to receive(:update_results).and_return('update_results')
      allow_any_instance_of(update).to receive(:verify_edit).and_return('verify_edit')
      s = update.new('opts', filepath)
      s.instance_variable_set(:@list, list)
      expect(s.edit_sub_task(1, 1, 'orig_value')).to eq 'update_results'
    end
  end

  context '.update_results' do
    it 'edits a sub task' do
      s = update.new('opts', filepath)
      s.instance_variable_set(:@list, list)
      expect(s.update_results('y', 1, 1, 1)).to eq 'display_results'
    end

    it 'edits a sub task' do
      s = update.new('opts', filepath)
      s.instance_variable_set(:@list, list)
      expect(s.update_results('n', 1, 1, 1)).to eq 'display_results'
    end
  end

  context '.verify_edit' do
    it 'verifies an edit' do
      allow_any_instance_of(update).to receive(:show_lists).and_return('show_lists')
      s = update.new('opts', filepath)
      expect(s.verify_edit('no')).to eq 'show_lists'
    end

    it 'verifies an edit' do
      allow_any_instance_of(update).to receive(:show_lists).and_return('show_lists')
      s = update.new('opts', filepath)
      expect(s.verify_edit('yes')).to eq true
    end
  end
end