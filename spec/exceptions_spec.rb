# frozen_string_literal: true

require_relative '../lib/exceptions'

RSpec.describe CheckList::Exceptions::InvalidListError do
  it{ expect { raise described_class  }.to raise_error CheckList::Exceptions::InvalidListError  }
end

RSpec.describe CheckList::Exceptions::CoverageError do
  it{ expect { raise described_class  }.to raise_error CheckList::Exceptions::CoverageError  }
end