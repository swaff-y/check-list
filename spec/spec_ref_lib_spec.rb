# frozen_string_literal: true

require_relative '../lib/spec_ref_lib'

# rubocop:disable Metrics/BlockLength
RSpec.describe SpecRefLib::Menu do
  let(:dummy_json) do
    {
      'categories' => [
        {
          'name' => 'Matchers',
          'example' => 'example',
          'keywords' => ['keyword']
        },
        {
          'name' => 'subject',
          'example' => 'example2',
          'keywords' => ['keyword2']
        }
      ]
    }
  end
  let(:menu) { described_class }

  context '.new' do
    before(:each) do
      allow(File).to receive(:dirname).and_return('here/')
      allow(File).to receive(:read).and_return('{}')
      allow(JSON).to receive(:parse).and_return(dummy_json)
      allow_any_instance_of(menu).to receive(:show_menu).and_return(true)
    end

    it 'initalizes correctly' do
      expect { menu.new }.not_to raise_error
    end
  end

  context '.show_menu' do
    before(:each) do
      allow(File).to receive(:dirname).and_return('here/')
      allow(File).to receive(:read).and_return('{}')
      allow(JSON).to receive(:parse).and_return(dummy_json)
      allow_any_instance_of(menu).to receive(:get_input).and_return(true)
    end

    it 'creates menu' do
      expect { menu.new }.not_to raise_error
    end
  end
end
# rubocop:enable Metrics/BlockLength
