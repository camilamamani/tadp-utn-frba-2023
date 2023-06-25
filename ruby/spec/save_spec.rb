describe 'Save Tests' do
  context 'Persistencia' do
    let(:alejandro){ Employee.new }
    after do
      TADB::DB.clear_all
    end
    before do
      class Employee
        include Persistence
        has_one String, named: :full_name
        has_one Numeric, named: :age
        has_one Boolean, named: :is_regular
      end
    end
    it 'Un empleado responde a id' do
      alejandro.full_name = "Alejandro"
      alejandro.age = 25
      alejandro.is_regular = true
      alejandro.save!
      expect(alejandro).to respond_to(:id)
    end
  end
  context 'Persistencia Array' do
    let(:origen){ Coordenada.new }
    before do
      class Coordenada
      include Persistence
      has_one Array, named: :posicion
      end
    end
    after do
      TADB::DB.clear_all
    end
    it 'Persistir un valor no primitivo da error' do
      origen.posicion = [0,0]
      expect{origen.save!}.to raise_error(PersistentAttribute::ValueIsNotAcceptableToPersist)
    end
  end
end