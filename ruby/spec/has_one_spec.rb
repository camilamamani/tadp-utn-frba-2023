describe 'Persistence Tests' do
  context 'has_one con atributos primitivos' do
    let(:one_raccoon){ Raccoon.new }
    before do
      class Raccoon
        include Persistence
        has_one String, named: :name
        has_one Boolean, named: :is_avenger
        has_one String, named: :age
        has_one Numeric, named: :age

      end
    end

    it 'Raccoon define atributo name con has_one' do
      expect(one_raccoon).to have_attributes(:name => nil)
    end

    it 'Raccoon define atributo booleano con has_one' do
      expect(one_raccoon).to have_attributes(:is_avenger => nil)
    end

    it 'Raccoon setea y lee sus atributos de forma normal' do
      one_raccoon.name = "Rocket Raccoon"
      expect(one_raccoon.name).to eq("Rocket Raccoon")
    end
    it 'Raccoon setea y lee sus atributos de forma normal' do
      one_raccoon.is_avenger = true
      expect(one_raccoon.is_avenger).to eq(true)
    end
  end

  context 'has_one con objetos' do
    let(:felipe){ Student.new }
    before do
      class Grade
        include Persistence
        has_one Numeric, named: :value
      end
      class Student
        include Persistence
        has_one String, named: :name
        has_one Grade, named: :grade
      end
    end
    it 'Se guarda estudiante y su nota' do
      felipe.name = 'Felipe'
      felipe.grade = Grade.new
      felipe.grade.value = 8
      felipe.save!
      expect(felipe).to respond_to(:id)
    end

    #TODO:Update all instances to return grade as object
    #expect(Student.all_instances.first.grade.value).to eq(8)
  end
end