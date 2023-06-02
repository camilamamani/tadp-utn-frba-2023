describe 'Herencia Tests' do
  context 'persistencia de clase que hereda de otra clase y que incluye otro modulo' do
    let(:juana){ UBAStudent.new }
    let(:juan){ AssistantProfessor.new }
    after do
      TADB::DB.clear_all
    end
    before do
      module RegularStudent
        include Persistence
        has_one String, named: :name
      end
      class UBAStudent
        include RegularStudent
        include Persistence
        has_one Integer, named: :age
      end
      class AssistantProfessor < UBAStudent
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
    it 'AssistantProfessor < Student include Person guarda todos los atributos en el mismo registro' do
      juan_db = AssistantProfessor.all_instances[0]
      expect(juan_db.name).to eq("Juan")
      expect(juan_db.age).to eq(20)
      expect(juan_db.type).to eq("Ayudante")
    end
    it 'Estudiante all instances devuelve estudiantes y ayudantes ' do
      expect(UBAStudent.all_instances.size).to eq(2)
    end
    it 'Estudiante find_by_name devuelve estudiante con name = Juana' do
      student_db = UBAStudent.find_by_name("Juana")
      expect(student_db[0].name).to eq("Juana")
      expect(student_db[0].age).to eq(22)
    end
    it 'Estudiante find_by_name devuelve ayudante con name = Juan' do
      student_db = UBAStudent.find_by_name("Juan")
      expect(student_db[0].name).to eq("Juan")
      expect(student_db[0].age).to eq(20)
      expect(student_db[0].type).to eq("Ayudante")
    end
  end
  context 'Modulo Tests' do
    let(:juana){ Producer.new }
    let(:juan){ AssistantProducer.new }
    after do
      TADB::DB.clear_all
    end
    before do
      module Staff
        include Persistence
        has_one String, named: :name
      end
      class Producer
        include Staff
        include Persistence
        has_one Integer, named: :age
      end
      class AssistantProducer < Producer
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
    it 'Modulo Person devuelve instancias de productores y asistentes' do
      expect(Staff.all_instances.size).to eq(2)
    end
  end
end