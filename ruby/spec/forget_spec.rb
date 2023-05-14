require "rspec"
require_relative '../lib/Persistence'
require_relative '../lib/Boolean'

describe 'Persistence Tests' do
  context 'forget' do
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
    it 'raises error if no id is found' do
      expect{Student.new.forget!}.to raise_error(Persistence::MissingIdError)

    end

    it 'deletes entry' do
      @one_student.full_name = "Alejandro"
      @one_student.age  = 25
      @one_student.save!

      @one_student.forget!

      expect(@one_student.id).to be(nil)

    end

  end
end
