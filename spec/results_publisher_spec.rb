# frozen_string_literal: true

require_relative '../lib/results_publisher'

RSpec.describe CheckList::ResultsPublisher do
  subject(:results_publisher) { described_class }
  let(:results) { { name: 'Development', ref: 'CA-123456'} }

  before do
    allow(CheckList::Helpers).to receive(:system_cmd).and_return('system_cmd')
  end

  context '.new' do
    before do
      allow_any_instance_of(subject).to receive(:publish_results).and_return('publish_results')
    end 

    it 'initalizes correctly' do
      expect { subject.new(results) }.not_to raise_error
    end
  end

  context '.publish_results' do
    # should do better testing here
    let(:data_hash){ { 'results' => [] } }
    let(:response_data_hash) { {"results"=>[{:name=>"Development", :ref=>"CA-123456"}, {:name=>"Development", :ref=>"CA-123456"}]} }

    before do
      allow_any_instance_of(subject).to receive(:create_checklist_folder).and_return('create_checklist_folder')
      allow_any_instance_of(subject).to receive(:write_json_file).and_return('write_json_file')
      allow(File).to receive(:read).and_return('file')
      allow(JSON).to receive(:parse).and_return(data_hash)
    end 

    it 'creates a checklist folder if there is none' do
      s = subject.new(results)
      s.instance_variable_set(:@checklist, '')
      expect(s.send(:publish_results)).to eq 'create_checklist_folder'
    end

    it 'returns a data hash' do
      s = subject.new(results)
      s.instance_variable_set(:@checklist, 'checklist')
      expect(s.send(:publish_results)).to eq response_data_hash
    end
  end

  context '.create_checklist_folder' do
    let(:response_data_hash) { {"results"=>[{:name=>"Development", :ref=>"CA-123456"}]} }
    
    before do
      allow(FileUtils).to receive(:mkdir_p).and_return('checklist')
      allow_any_instance_of(subject).to receive(:write_json_file).and_return('write_json_file')
      allow_any_instance_of(subject).to receive(:publish_results).and_return('publish_results')
    end

    it 'returns a data hash' do 
      expect(subject.new(results).send(:create_checklist_folder)).to eq response_data_hash
    end
  end

  context '.write_json_file' do
    let(:response_data_hash) { {"results"=>[{:name=>"Development", :ref=>"CA-123456"}]} }
    let(:data_hash){ { 'results' => [] } }

    before do
      allow(File).to receive(:write).and_return('file')
      allow_any_instance_of(subject).to receive(:publish_results).and_return('publish_results')
    end
    
    it 'writes a json file' do
      expect(subject.new(results).send(:write_json_file, data_hash: data_hash )).to eq 'file'
    end
  end
end