describe 'Herencia' do

  context 'cuando se quiere persistir una clase que incluye un modulo' do
    let(:juana){ Student.new }
    let(:juan){ AssistantProfessor.new }
    before do
      module Person
        include Persistence
        has_one String, named: :name
      end
      class Student
        include Persistence
        include Person
        has_one Numeric, named: :age
      end
      class AssistantProfessor < Student
        include Persistence
        has_one String, named: :type
      end
      juana.name = "Juana"
      juana.age = 22
      juana.save!

      juan.name = "Juan"
      juan.age = 20
      juan.type = "Ayudante"
      juan.save!
    end

    it 'se guardan todos los atributos para la instancia de student' do
      expect(juana.name).to eq("Juana")
      expect(juana.age).to eq(22)
    end
    it 'se guardan todos los atributos en el mismo registro de la bd' do
      juana_db = Student.all_instances[0]
      expect(juana_db.name).to eq("Juana")
      expect(juana_db.age).to eq(22)
    end
    it 'se guardan todos los atributos en el mismo registro de la bd' do
      juan_db = AssistantProfessor.all_instances[0]
      expect(juan_db.name).to eq("Juan")
      expect(juan_db.age).to eq(20)
      expect(juan_db.type).to eq("Ayudante")
    end
  end

end