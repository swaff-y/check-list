# frozen_string_literal: true

require_relative '../lib/version'

RSpec.describe SpecRefLib::Version do
  let(:subject) { SpecRefLib::Version }
  it { expect(subject.version).to eq '0.0.0' }
end
