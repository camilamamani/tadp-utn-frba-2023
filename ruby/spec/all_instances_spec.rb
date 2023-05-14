require 'rspec'
require_relative '../lib/Persistence'
require_relative '../lib/Boolean'

describe 'AllInstances' do

  context 'all_instances' do

    before do
      class Student
        include Persistence
        has_one String, named: :full_name
        has_one Numeric, named: :age
        has_one Boolean, named: :is_regular
      end
      @one_student = Student.new
    end

    after do
      TADB::DB.clear_all
    end

    it 'returns all instances of a class' do
      @one_student.full_name = "Alejandro"
      @one_student.age  = 25
      @one_student.save!

      expect(Student.all_instances.size).to eq(1)
    end
  end
end
