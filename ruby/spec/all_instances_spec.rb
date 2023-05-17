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
        def ==(other)
          self.class == other.class && name == other.name && age == other.age && is_regular == other.is_regular
        end
      end
      @one_student = Student.new
      @one_student.name = "Alejandro"
      @one_student.age  = 25
      @one_student.save!

      @other_student = Student.new
      @other_student.name = "Fernando"
      @other_student.age  = 30
      @other_student.save!

    end

    after do
      TADB::DB.clear_all
    end

    it 'returns all instances of a students that are saved' do
      expect(Student.all_instances.size).to eq(2)
    end

    it 'returns all instances of a students that are saved except the ones forgot' do
      @other_student.forget!
      expect(Student.all_instances.size).to eq(1)
    end

    it 'all instances returned are actual classes and can be updated' do
      @student_a = Student.all_instances[0]
      @student_a.name = "Student A"
      @student_a.save!

      expected_student = Student.new
      expected_student.id= @student_a.id
      expected_student.name= @student_a.name
      expected_student.age=@student_a.age
      expected_student.is_regular= @student_a.is_regular
      expect(Student.all_instances.include?(expected_student)).to eq(true)
      expect(Student.all_instances.size).to eq(2)
    end

  end
end
