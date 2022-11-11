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

  before do
    allow(File).to receive(:dirname).and_return('here/')
    allow(File).to receive(:read).and_return('{}')
    allow(JSON).to receive(:parse).and_return(dummy_json)
    allow_any_instance_of(menu).to receive(:clear).and_return(true)
    allow_any_instance_of(menu).to receive(:log).and_return(true)
  end

  context '.new' do
    before(:each) do
      allow_any_instance_of(menu).to receive(:show_menu).and_return(true)
    end
    it 'initalizes correctly' do
      expect { menu.new }.not_to raise_error
    end
  end

  context '.show_menu' do
    before(:each) do
      allow_any_instance_of(menu).to receive(:get_input).and_return(true)
    end

    it 'creates menu' do
      m = menu.new
      expect { m.show_menu }.not_to raise_error
    end
  end

  context '.show_sub_menu' do
    let(:arr) { [{ 'name' => 'test' }, { 'name' => 'test2' }] }
    before(:each) do
      allow_any_instance_of(menu).to receive(:show_menu).and_return(true)
      allow_any_instance_of(menu).to receive(:get_input).and_return(true)
    end

    it 'creates a sub menu' do
      m = menu.new
      expect { m.show_sub_menu(arr, 'sub_menu') }.not_to raise_error
    end
  end

  context '.show_example' do
    before(:each) do
      allow_any_instance_of(menu).to receive(:show_menu).and_return(true)
      allow_any_instance_of(menu).to receive(:get_input).and_return(true)
    end

    it 'creates an example' do
      m = menu.new
      expect { m.show_example('example') }.not_to raise_error
    end
  end

  context '.get_input' do
    let(:arr) { { 'categories' => %w[cat1 cat2] } }
    let(:arr2) { %w[cat1 cat2] }
    before(:each) do
      allow_any_instance_of(menu).to receive(:show_menu).and_return(true)
      allow_any_instance_of(menu).to receive(:list_validator).and_return(1)
      allow_any_instance_of(menu).to receive(:show_sub_menu).and_return(true)
      allow_any_instance_of(menu).to receive(:show_example).and_return(true)
    end

    it 'gets an list_selector input' do
      m = menu.new
      allow(m).to receive(:ret_value).and_return(1)
      expect { m.get_input('list_selector', arr) }.not_to raise_error
    end

    it 'gets an sub_list_selector input' do
      m = menu.new
      allow(m).to receive(:ret_value).and_return(1)
      expect { m.get_input('sub_list_selector', arr2) }.not_to raise_error
    end

    it 'gets an end_list_selector input' do
      m = menu.new
      allow(m).to receive(:ret_value).and_return(1)
      expect { m.get_input('end_list_selector', arr2) }.not_to raise_error
    end
  end
end
# rubocop:enable Metrics/BlockLength
