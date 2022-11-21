# frozen_string_literal: true

require_relative '../lib/exceptions'

RSpec.describe CheckList::Exceptions::InvalidListError do
  it{ expect { raise described_class, 'Invalid List'  }.to raise_error 'Invalid List'  }
end