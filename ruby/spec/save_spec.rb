describe 'Persistence Tests' do
  context '2. save' do
    let(:one_student){ Student.new }
    before do
      class Student
        include Persistence
        has_one String, named: :full_name
        has_one Numeric, named: :age
        has_one Boolean, named: :is_regular
      end

    end

    after do
      TADB::DB.clear_all
    end

    it 'Un estudiante responde a id' do
      one_student.full_name = "Alejandro"
      one_student.age  = 25
      one_student.is_regular = true
      one_student.save!

      expect(one_student).to respond_to(:id)
    end

  end
end