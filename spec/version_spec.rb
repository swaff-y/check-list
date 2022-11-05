# frozen_string_literal: true

require_relative '../lib/version'

RSpec.describe Specr::Version do
  let(:subject) { Specr::Version }
  it { expect(subject.version).to eq '0.0.0' }
end
