# frozen_string_literal: true

require_relative '../lib/handle_file'

RSpec.describe SpecRefLib::HandleFile do
  let(:file_handler) { described_class }

  context '.new' do
    before do
      allow_any_instance_of(file_handler).to receive(:fetch_default_file).and_return('default_file')
    end

    it 'initalizes correctly' do
      expect { file_handler.new }.not_to raise_error
    end
  end

  context '.fetch_default_file' do
    before do
      allow(SpecRefLib::Config).to receive(:default_url).and_return('url')
      allow(URI).to receive(:parse).and_return('URI')
      allow(Net::HTTP).to receive(:get_response).and_return('response')
    end

    it 'gets data from a correct url' do
      f = file_handler.new
      expect(f.fetch_default_file).to eq 'response'
    end

    it 'returns nil if error occurs' do
      allow(Net::HTTP).to receive(:get_response).and_raise StandardError
      f = file_handler.new
      expect(f.fetch_default_file).to eq nil
    end
  end
end
