# frozen_string_literal: true

# creates a symbolized hash
class Sym
  attr_reader :hash

  def initialize(hash)
    @hash = hash
    @hash = process_hash(@hash)
  end

  def process_hash(hash)
    hash.transform_keys!(&:to_sym)
    keys = hash.keys
    new_hash = {}

    keys.each do |key|
      new_hash[key] = hash[key]
      new_hash[key] = process_hash(hash[key]) if hash[key].is_a? Hash
      new_hash[key] = process_array(hash[key]) if hash[key].is_a? Array
    end
    new_hash
  end

  def process_array(array)
    new_array = []

    array.each do |item|
      new_array.push item unless item.is_a?(Array) || item.is_a?(Hash)
      new_array.push process_array(item) if item.is_a? Array
      new_array.push process_hash(item) if item.is_a? Hash
    end
    new_array
  end
end
