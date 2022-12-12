# frozen_string_literal: true

require_relative '../lib/menu'
require_relative '../lib/results'

RSpec.describe CheckList::Menu do
  subject(:menu) { described_class }
  let(:opts) { double('options')}
  let(:filepath_lists) { { 'lists' => [{ 'name' => 'list1' }, { 'name' => 'list2'}] } }
  let(:filepath) { double('filepath', fetch_json: filepath_lists) }
  let(:process_value) { double('process_value')} 
  let(:results) { instance_double(CheckList::Results, process_results: 'process', process_value: process_value)}

  before do
    allow(CheckList::Results).to receive(:new).and_return(results)
    allow(CheckList::Helpers).to receive(:log).and_return('log')
    allow(CheckList::Helpers).to receive(:clear).and_return('clear')
    allow(CheckList::Helpers).to receive(:leave).and_return('leave')
    allow(CheckList::Helpers).to receive(:ret_value).and_return('ret_value')
  end

  context '.new' do
    it 'initalizes without error' do
      allow_any_instance_of(menu).to receive(:show_menu).and_return('show_menu')
      expect { subject.new(filepath, opts) }.not_to raise_error
    end
  end

  context '.show_menu' do
    before do
      allow_any_instance_of(menu).to receive(:show_tasks).and_return('show_tasks')
      allow(CheckList::Helpers).to receive(:good_bye).and_return('good_bye')
    end

    it 'leaves when 0' do
      allow(CheckList::Validations).to receive(:validate).and_return(0)
      expect(subject.new(filepath, opts).show_menu).to eq 'good_bye'
    end

    it 'shows tasks if not zero' do
      allow(CheckList::Validations).to receive(:validate).and_return(1)
      allow_any_instance_of(menu).to receive(:get_list).and_return(1)
      expect(subject.new(filepath, opts).show_menu).to eq 'show_tasks'
    end

    it 'calls itself if ' do
      allow(CheckList::Validations).to receive(:validate).and_return(1)
      allow_any_instance_of(menu).to receive(:get_list).and_return(nil)
      allow_any_instance_of(menu).to receive(:rec_show_menu).and_return('show_menu')
      expect(subject.new(filepath, opts).show_menu).to eq 'show_menu'
    end
  end

  context '.rec_show_menu' do
    before do 
      allow_any_instance_of(menu).to receive(:show_menu).and_return('show_menu') 
    end
    it { expect(subject.new(filepath, opts).rec_show_menu).to eq 'show_menu' }
  end

  context '.show_tasks' do
    before do
      allow_any_instance_of(menu).to receive(:show_menu).and_return('show_menu')
      allow_any_instance_of(menu).to receive(:show_sub_tasks).and_return('show_sub_tasks')
    end

    it 'sets task index to 0' do
      s = subject.new(filepath, opts)
      s.instance_variable_set(:@task_idx, nil)
      s.instance_variable_set(:@list, {'tasks' => ['one']})
      expect(s.show_tasks).to eq 'show_sub_tasks'
    end
  end

  context '.show_sub_tasks' do
    before do
      allow_any_instance_of(menu).to receive(:show_menu).and_return('show_menu')
      allow(CheckList::Helpers).to receive(:good_bye).and_return('good_bye')
    end

    it 'returns if task index == task list length' do
      s = subject.new(filepath, opts)
      s.instance_variable_set(:@task_idx, 1)
      s.instance_variable_set(:@list, {'tasks' => [{ 'name' => 'first task'}]})
      expect(s.show_sub_tasks).to eq nil
    end

    it 'leaves if q is typed' do
      allow(CheckList::Validations).to receive(:validate_response).and_return('q')
      s = subject.new(filepath, opts)
      s.instance_variable_set(:@task_idx, 0)
      s.instance_variable_set(:@list, {'tasks' => [{ 'name' => 'first task', 'subTasks' => [{'name'=>'task1'},{'name' => 'task2'}]}]})
      expect(s.show_sub_tasks).to eq 'good_bye'
    end

    it 'if 0 is typed' do
      allow(CheckList::Validations).to receive(:validate_response).and_return(0)
      allow_any_instance_of(menu).to receive(:rec_show_sub_tasks).and_return('show_sub_tasks')
      s = subject.new(filepath, opts)
      s.instance_variable_set(:@task_idx, 0)
      s.instance_variable_set(:@list, {'tasks' => [{ 'name' => 'first task', 'subTasks' => [{'name'=>'task1'},{'name' => 'task2'}]}]})
      s.show_sub_tasks
      expect(s.instance_variable_get(:@sub_task_idx )).to eq 0
    end

    it 'if value is less than length' do
      allow(CheckList::Validations).to receive(:validate_response).and_return(1)
      allow_any_instance_of(menu).to receive(:rec_show_sub_tasks).and_return('show_sub_tasks')
      s = subject.new(filepath, opts)
      s.instance_variable_set(:@task_idx, 0)
      s.instance_variable_set(:@list, {'tasks' => [{ 'name' => 'first task', 'subTasks' => [{'name'=>'task1'},{'name' => 'task2'}]}]})
      expect(s.show_sub_tasks).to eq 'show_sub_tasks'
    end

    it 'if value is less than length' do
      allow(CheckList::Validations).to receive(:validate_response).and_return(2)
      allow_any_instance_of(menu).to receive(:show_tasks).and_return('show_tasks')
      s = subject.new(filepath, opts)
      s.instance_variable_set(:@task_idx, 0)
      s.instance_variable_set(:@list, {'tasks' => [{ 'name' => 'first task', 'subTasks' => [{'name'=>'task1'},{'name' => 'task2'}]}]})
      expect(s.show_sub_tasks).to eq 'show_tasks'
    end
  end

  context '.get_list' do
    it{ expect(subject.new(filepath, opts).get_list(1)).to eq filepath_lists['lists'][0] }
  end
end