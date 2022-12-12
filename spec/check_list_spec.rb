# frozen_string_literal: true

require_relative '../lib/check_list'

RSpec.describe CheckList::Start do
  subject(:start){ described_class }
  let(:update_given) { { update_given: true } }
  let(:update_ref_given) { { update_given: true, list_given: true, ref_given: true } }
  let(:view_given) { { view_given: true } }
  let(:view_ref_given) { { view_given: true, list_given: true, ref_given: true } }
  let(:monkey_given) { { monkey_given: true } }

  describe '.new' do
    before do
      allow(CheckList::HandleFile).to receive(:new).and_return('filepath')
      allow_any_instance_of(start).to receive(:set_options).and_return('options')
      allow_any_instance_of(start).to receive(:handler).and_return('handler')
    end

    it 'should initialize without error' do
      expect { start.new }.not_to raise_error
    end
  end

  describe '.set_options' do
    before do
      allow(CheckList::HandleFile).to receive(:new).and_return('filepath')
      allow(Optimist).to receive(:options).and_return('options')
      allow_any_instance_of(start).to receive(:handler).and_return('handler')
    end

    it 'set options' do
      s = start.new
      expect { s.set_options }.not_to raise_error
    end
  end

  describe '.handler' do
    before do  
      allow(CheckList::HandleFile).to receive(:new).and_return('filepath')
      allow(CheckList::Menu).to receive(:new).and_return('menu')
      allow(CheckList::Helpers).to receive(:log).and_return('log')
      allow_any_instance_of(start).to receive(:update).and_return('update')
      allow_any_instance_of(start).to receive(:view).and_return('view')
    end

    it 'returns update' do
      allow(Optimist).to receive(:options).and_return(update_given)
      expect(start.new.handler).to eq 'update'
    end

    it 'returns view' do
      allow(Optimist).to receive(:options).and_return(view_given)
      expect(start.new.handler).to eq 'view'
    end

    it 'returns menu' do
      allow(Optimist).to receive(:options).and_return(monkey_given)
      expect(start.new.handler).to eq 'menu'
    end

    it 'recovers from an error' do
      allow(CheckList::Menu).to receive(:new).and_raise CheckList::Exceptions::InvalidOptionError
      allow(Optimist).to receive(:options).and_return(monkey_given)
      expect(start.new.handler).to eq 'log'
    end
  end

  describe '.update' do
    before do
      allow(CheckList::Update).to receive(:new).and_return('update')
    end

    it 'returns update ref' do
      allow(CheckList::HandleFile).to receive(:new).and_return('filepath')
      allow(Optimist).to receive(:options).and_return(update_ref_given)
      allow_any_instance_of(start).to receive(:update_ref).and_return('update_ref')
      expect(start.new.update).to eq 'update_ref'
    end

    it 'returns update ref' do
      allow(CheckList::HandleFile).to receive(:new).and_return('filepath')
      allow(Optimist).to receive(:options).and_return(update_given)
      allow_any_instance_of(start).to receive(:update_list).and_return('update_list')
      expect(start.new.update).to eq 'update_list'
    end
  end

  describe '.update_ref' do 

  end

  describe '.update_list' do 

  end

  describe '.update_list' do 

  end

  describe '.view' do
    it 'returns view ref' do
      allow(CheckList::HandleFile).to receive(:new).and_return('filepath')
      allow(Optimist).to receive(:options).and_return(view_ref_given)
      allow_any_instance_of(start).to receive(:view_ref).and_return('view_ref')
      expect(start.new.view).to eq 'view_ref'
    end

    it 'returns view ref' do
      allow(CheckList::HandleFile).to receive(:new).and_return('filepath')
      allow(Optimist).to receive(:options).and_return(view_given)
      allow_any_instance_of(start).to receive(:view_list).and_return('view_list')
      expect(start.new.view).to eq 'view_list'
    end


  end

  describe '.view_ref' do 

  end

  describe '.view_list' do 

  end


end