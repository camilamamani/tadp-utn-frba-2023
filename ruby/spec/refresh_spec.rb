require "rspec"
require "tadb"
require_relative '../lib/Persistence'
require_relative '../lib/Boolean'

describe 'Persistence Tests' do
  context '3. refresh' do
    before do
      class Student
        include Persistence
        has_one String, named: :full_name
        has_one Numeric, named: :age
      end
      @one_student = Student.new
    end

    after do
      TADB::DB.clear_all
    end

    it 'refresh da error cuando id es nul' do
      expect{Student.new.refresh!}.to raise_error(Persistence::MissingIdError)
    end

    it 'refresh' do
      @one_student.full_name = "Alejandro"
      @one_student.age  = 25
      @one_student.save!

      @one_student.full_name = "Tobias"
      @one_student.age = 29
      @one_student.refresh!

      expect(@one_student.full_name).to eq("Alejandro")
      expect(@one_student.age).to eq(25)
    end

  end
end