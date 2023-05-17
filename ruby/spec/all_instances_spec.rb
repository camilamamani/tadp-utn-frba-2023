require 'rspec'
require_relative '../lib/Persistence'
require_relative '../lib/Boolean'

describe 'AllInstances' do

  context 'all_instances' do

    before do
      class Student
        include Persistence
        has_one String, named: :name
        has_one Numeric, named: :age
        has_one Boolean, named: :is_regular
      end
      @one_student = Student.new
      @one_student.name = "Alejandro"
      @one_student.age  = 25
      @one_student.save!
    end

    after do
      TADB::DB.clear_all
    end

    it 'returns all instances of a class that are saved' do
      @other_student = Student.new
      @other_student.name = "Fernando"
      @other_student.age  = 30
      @other_student.save!

      expect(Student.all_instances.size).to eq(2)
    end

    it 'all instances returned are actual classes and can be updated' do
      @one_student.name = "Pablo"
      @one_student.save!

      @student_a = Student.all_instances.first
      @student_a.name = "Student A"
      @student_a.save!

      expect(Student.all_instances.first.name).to eq("Student A")
    end
  end
end
