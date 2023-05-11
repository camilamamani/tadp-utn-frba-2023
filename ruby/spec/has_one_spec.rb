require "rspec"
require_relative '../lib/Persistence'

describe 'has_one tests' do
    before do
      class Raccoon
        include Persistence
        has_one String, named: :name
      end
      @one_raccoon = Raccoon.new
    end

    it 'Raccoon define atributo name con has_one' do
      expect(@one_raccoon).to have_attributes(:name => nil)
    end
end