describe 'Persistence Tests' do
  context 'forget' do
    let(:sabrina){ Student.new }
    let(:pablo){ Student.new }

    before do
      class Student
        include Persistence
        has_one String, named: :name
        has_one Integer, named: :age
        has_one Boolean, named: :is_regular

      end

      sabrina.name = 'Sabrina'
      sabrina.age = 19
      sabrina.is_regular = true
      sabrina.save!

      pablo.name = 'Pablo'
      pablo.age = 30
      pablo.is_regular = true
      pablo.save!

    end

    after do
      TADB::DB.clear_all
    end

    it 'test find by name Sabrina ' do
      students = Student.find_by_name('Sabrina')
      expect(students.size).to eq(1)
      expect(students[0].name).to eq('Sabrina')
    end

    it 'test find by age 30 ' do
      students = Student.find_by_age(30)
      expect(students.size).to eq(1)
      expect(students[0].name).to eq('Pablo')
    end

    it 'test find by is_regular true ' do
      students = Student.find_by_is_regular(true)
      expect(students.size).to eq(2)
    end

  end
end
