# frozen_string_literal: true

require_relative '../lib/symbolize'

RSpec.describe Sym do
  let(:sym) { described_class }
  let(:hash) { { 
    'String' => 'A string',
    'Integer' => 1,
    'Object' => {
      'String' => 'A string',
      'Integer' => 2
    },
    'Array' => [
      'string',
      1,
      {
        'String' => 'A string',
        'Integer' => 1,
        'Object' => {
          'String' => 'A string',
          'Integer' => 2
        },
        'Array' => [
          'string',
          'string2'
        ]
      }
    ]
  } }
  let(:expected_hash) { { 
    :String => 'A string',
    :Integer => 1,
    :Object => {
      :String => 'A string',
      :Integer => 2
    },
    :Array => [
      'string',
      1,
      {
        :String => 'A string',
        :Integer => 1,
        :Object => {
          :String => 'A string',
          :Integer => 2
        },
        :Array => [
          'string',
          'string2'
        ]
      }
    ]
  } }
  
  it { expect(sym.new(hash).hash).to eq expected_hash }

  it { expect { sym.new('').hash }.to raise_error CheckList::Exceptions::NotAHash, 'Please pass a valid hash' }
end