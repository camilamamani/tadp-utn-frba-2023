require "rspec"
require_relative '../lib/Raccoon'

describe 'raccoon has_one tests' do
  let(:one_raccoon){
    Raccoon.new
  }
  it 'raccoon define atributos con has_one' do
    one_raccoon.full_name = "Rocket Raccoon"
    one_raccoon.has_one(String, {named: :full_name})

  end
end