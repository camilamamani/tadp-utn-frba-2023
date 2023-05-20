describe 'Persistence Tests' do
  context 'has_many con objetos' do
    let(:pablo){ Student.new }
    before do
      class Grade
        include Persistence
        has_one Numeric, named: :value
      end
      class Student
        include Persistence
        has_one String, named: :name
        has_many Grade, named: :grades
      end
      pablo.name = "Pablo"
    end
    after do
      TADB::DB.clear_all
    end
    it 'Se guarda estudiante y notas con has_many, notas inicializado con []' do
      expect(pablo.grades).to eq([])
    end
    it 'Se guarda estudiante y notas' do
      pablo.grades.push(Grade.new)
      pablo.grades.last.value = 8
      pablo.grades.push(Grade.new)
      pablo.grades.last.value = 5
      pablo.save!

      expect(pablo.grades.size).to eq(2)
      expect(pablo.grades.last.value).to eq(5)
    end

    it 'Se guarda estudiante y notas, con refresh actualizamos notas' do
      pablo.grades.push(Grade.new)
      pablo.grades.last.value = 10
      pablo.save!

      pablo.grades.last.value = 0
      pablo.refresh!

      expect(pablo.grades.last.value).to eq(10)
    end
  end
end