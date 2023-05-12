require "rspec"
require_relative '../lib/Persistence'
require_relative '../lib/Boolean'

describe 'has_one tests' do
    before do
      class Raccoon
        include Persistence
        has_one String, named: :name
        has_one Boolean, named: :is_Avenger

        attr_accessor :energy
      end
      @one_raccoon = Raccoon.new
    end

    it 'Raccoon define atributo name con has_one' do
      expect(@one_raccoon).to have_attributes(:name => nil)
    end

    it 'Raccoon define atributo booleano con has_one' do
      expect(@one_raccoon).to have_attributes(:is_Avenger => nil)
    end
end