describe 'Persistence Tests' do
  context 'validate' do
    let(:alejandro){ Student.new }
    before do
      class Course
        include Persistence
        has_one Integer, named: :hours
      end
      class Grade
        include Persistence
        has_one Integer, named: :value
      end
      class Student
        include Persistence
        has_one String, named: :full_name, no_blank: true
        has_one Integer, named: :age ,from: 5, to: 18
        has_one Boolean, named: :is_regular
        has_one Grade, named: :grade, validate: proc{ |x| x.value > 2 }
        has_many Course, named: :courses, validate: proc{ |x| x.hours > 20 }
        has_one String, named: :surname, default: "perez"
      end
    end

    after do
      TADB::DB.clear_all
    end

    it 'Al momento de inicializar el estudiante, surname es perez' do
      expect(alejandro.surname).to eq("perez")
    end

    it 'Al momento de inicializar el estudiante, cursos es []' do
      expect(alejandro.courses).to eq([])
    end

    it 'Validate da error si campo full_name es numero' do
      alejandro.full_name = 55
      expect{alejandro.save!}.to raise_error(PersistentAttribute::TypeError)
    end

    it 'Validate da TypeError si campo es no_blank true' do
      alejandro.full_name = ""
      expect{alejandro.save!}.to raise_error(PersistentAttribute::TypeError)
    end

    it 'Validate da FromError si campo es < from value' do
      alejandro.full_name = "alejandro"
      alejandro.age = 2
      expect{alejandro.save!}.to raise_error(PersistentAttribute::FromError)
    end
    it 'Validate da ToError si campo es > to value' do
      alejandro.full_name = "alejandro"
      alejandro.age = 20
      expect{alejandro.save!}.to raise_error(PersistentAttribute::ToError)
    end
    it 'Validate da ValidateError si grade no cumple con proc value>2' do
      alejandro.full_name = "alejandro"
      alejandro.age = 15
      alejandro.grade = Grade.new
      alejandro.grade.value = 1
      expect{alejandro.save!}.to raise_error(PersistentAttribute::ValidateError)
    end
    it 'Validate da ValidateError si los cursos no cumplen con proc hours>20' do
      alejandro.full_name = "alejandro"
      alejandro.age = 15
      alejandro.grade = Grade.new
      alejandro.grade.value = 10
      alejandro.courses.push(Course.new)
      alejandro.courses.last.hours = 15
      expect{alejandro.save!}.to raise_error(PersistentAttribute::ValidateError)
    end

    it 'Validate no da ningun error si atributos satisfacen condiciones' do
      alejandro.full_name = "alejandro"
      alejandro.age = 15
      alejandro.is_regular = true
      alejandro.grade = Grade.new
      alejandro.grade.value = 10
      alejandro.courses.push(Course.new)
      alejandro.courses.last.hours = 22
      expect{alejandro.save!}.not_to raise_error(StandardError)
    end

    it 'Al momento de guardar si hay alguna variable con valor de inicializacion vacio da error' do
      alejandro.full_name = "alejandro"
      alejandro.age = 15
      alejandro.grade = Grade.new
      alejandro.grade.value = 10
      alejandro.courses.push(Course.new)
      alejandro.courses.last.hours = 22
      expect{alejandro.save!}.to raise_error(PersistentAttribute::UnInitializedVariable)
    end
  end
end