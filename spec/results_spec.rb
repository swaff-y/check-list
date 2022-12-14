# frozen_string_literal: true

require_relative '../lib/validations'
require_relative '../lib/exceptions'

RSpec.describe CheckList::Results do
  let(:opts) { double("options")}
  let(:results) { described_class.new(opts) }
  let(:list) { { 'name' => 'Tom' } }
  let(:task) { { 'name' => 'Do something' } }
  let(:sub_task) { { 'name' => 'Do sub something' } }
  let(:value) { 'value' }
  let(:result) { [ {
    list: list['name'], 
    task: task['name'], 
    subTask: sub_task['name'], 
    value: value, 
    timestamp: '2022-11-22 10:57' 
  } ]}

  context '.new' do
    before do
      allow_any_instance_of(described_class).to receive(:process_opts).and_return('process_results')
    end
    it { expect { results }.not_to raise_error  }
  end

  context '.process_opts' do
    let(:results) { described_class }
    let(:opts) { { ref: "CA-123456"} }
    let(:nil_opts) { { ref: nil } }
    subject(:res) { results.new(opts) }
    subject(:res_nil) { results.new(nil_opts) }

    before do
      allow(CheckList::Helpers).to receive(:system_cmd).and_return('CA-123456')
      allow(CheckList::Helpers).to receive(:log).and_return('log')
    end

    it 'reference is not nil' do
      expect(res.process_opts).to eq 'CA-123456'
    end

    it 'reference is nil' do
      expect(res_nil.process_opts).to eq 'CA-123456'
    end

    it 'recovers if an error is thrown' do
      allow(CheckList::Helpers).to receive(:system_cmd).and_raise
      expect(res_nil.process_opts).to eq 'main'
    end
  end

  context '.process_value' do
    before do
      allow(CheckList::Config).to receive(:time_now).and_return('2022-11-22 10:57')
      allow_any_instance_of(described_class).to receive(:process_opts).and_return('process_results')
    end
    it{ expect(results.process_value(list, value, task, sub_task)).to eq result}
  end

  context '.process_results' do
    let(:results) { described_class }
    subject(:res) { results.new(opts) }

    before do
      allow(CheckList::Config).to receive(:time_now).and_return('2022-11-22 10:57')
      allow(CheckList::Helpers).to receive(:clear).and_return('clear')
      allow(CheckList::Helpers).to receive(:log).and_return('log')
      allow(CheckList::Helpers).to receive(:leave).and_return('leave')
      allow(CheckList::ResultsPublisher).to receive(:new).and_return('results_publisher')
      allow(CheckList::DisplayResults).to receive(:new).and_return('display_results')
      allow_any_instance_of(results).to receive(:create_results_list).and_return('create_results_list')
      allow_any_instance_of(results).to receive(:create_tasks).and_return('create_tasks')
      allow_any_instance_of(results).to receive(:add_sub_tasks).and_return('add_sub_tasks')
      allow_any_instance_of(results).to receive(:update_tasks).and_return('update_tasks')
      allow_any_instance_of(results).to receive(:process_opts).and_return('process_results')
    end

    it { expect(res.process_results).to eq 'display_results' }

    it 'raises an error' do 
      allow_any_instance_of(results).to receive(:create_tasks).and_raise CheckList::Exceptions::InvalidListError, 'invalid'
      expect(res.process_results).to eq 'leave'
    end

    it 'raises an error' do 
      allow_any_instance_of(results).to receive(:create_tasks).and_raise StandardError, 'invalid'
      expect(res.process_results).to eq 'leave'
    end
  end

  context '.update_tasks' do
    subject(:results) { described_class }

    before do
      allow(CheckList::Config).to receive(:time_now).and_return('2022-11-22 10:57')
      allow(CheckList::Helpers).to receive(:clear).and_return('clear')
      allow(CheckList::Helpers).to receive(:log).and_return('log')
      allow(CheckList::Helpers).to receive(:leave).and_return('leave')
      allow_any_instance_of(results).to receive(:process_opts).and_return('process_results')
    end

    it 'is expected not to raise' do
      s = subject.new(opts)
      s.instance_variable_set(:@results, { tasks: [{subTasks: [{status: 'y'}, {status: 'n'}]}, {subTasks: [{status: 'y'}, {status: 'n'}]}]})
      expect { s.send(:update_tasks) }.not_to raise_error
    end
  end

  context '.add_sub_tasks' do
    subject(:results) { described_class }

    before do
      subject.instance_variable_set(:@results, { tasks: [{name: 'task', subTasks: [{status: 'y'}, {status: 'n'}]}, {name: 'another task', subTasks: [{status: 'y'}, {status: 'n'}]}]})
      subject.instance_variable_set(:@results_array, [{ task: 'task', subTask: 'subTask', value: 'value', timestamp: '2022-11-22 10:57'}])
      allow(CheckList::Config).to receive(:time_now).and_return('2022-11-22 10:57')
      allow(CheckList::Helpers).to receive(:clear).and_return('clear')
      allow(CheckList::Helpers).to receive(:log).and_return('log')
      allow(CheckList::Helpers).to receive(:leave).and_return('leave')
      allow_any_instance_of(results).to receive(:process_opts).and_return('process_results')
    end

    it 'is expected not to raise' do
      s = subject.new(opts)
      s.instance_variable_set(:@results, { tasks: [{name: 'task', subTasks: [{status: 'y'}, {status: 'n'}]}, {name: 'another task', subTasks: [{status: 'y'}, {status: 'n'}]}]})
      s.instance_variable_set(:@results_array, [{ task: 'task', subTask: 'subTask', value: 'value', timestamp: '2022-11-22 10:57'}])
      expect { s.send(:add_sub_tasks) }.not_to raise_error 
    end
  end

  context '.create_tasks' do
    subject(:results) { described_class }

    before do
      allow(CheckList::Config).to receive(:time_now).and_return('2022-11-22 10:57')
      allow(CheckList::Helpers).to receive(:clear).and_return('clear')
      allow(CheckList::Helpers).to receive(:log).and_return('log')
      allow(CheckList::Helpers).to receive(:leave).and_return('leave')
      allow_any_instance_of(results).to receive(:process_opts).and_return('process_results')
    end

    it 'is not expected to raise' do
      s = subject.new(opts)
      s.instance_variable_set(:@results, { name: 'list' })
      s.instance_variable_set(:@results_array, [{ task: 'task', subTask: 'subTask', value: 'value', timestamp: '2022-11-22 10:57'}, { task: 'task', subTask: 'subTask', value: 'value', timestamp: '2022-11-22 10:57'}, { task: 'another task', subTask: 'another subTask', value: 'value', timestamp: '2022-11-22 10:57'}])
      expect { s.send(:create_tasks) }.not_to raise_error
    end
  end

  context '.create_results_list' do
    subject(:results) { described_class }

    before do
      allow(CheckList::Config).to receive(:time_now).and_return('2022-11-22 10:57')
      allow(CheckList::Helpers).to receive(:clear).and_return('clear')
      allow(CheckList::Helpers).to receive(:log).and_return('log')
      allow(CheckList::Helpers).to receive(:leave).and_return('leave')
      allow_any_instance_of(results).to receive(:process_opts).and_return('process_results')
    end

    it 'is expected not to raise' do
      s = subject.new(opts)
      s.instance_variable_set(:@results_array, [{ list: 'list', task: 'task', subTask: 'subTask', value: 'value', timestamp: '2022-11-22 10:57'}])
      expect { s.send(:create_results_list) }.not_to raise_error
    end

    it 'rasies if list incorrect' do
      s = subject.new(opts)
      s.instance_variable_set(:@results_array, [{ list: 'list', task: 'task', subTask: 'subTask', value: 'value', timestamp: '2022-11-22 10:57'}, { list: 'another list', task: 'task', subTask: 'subTask', value: 'value', timestamp: '2022-11-22 10:57'}])
      expect { s.send(:create_results_list) }.to raise_error CheckList::Exceptions::InvalidListError, 'The list can only contain one list title'
    end
  end
end