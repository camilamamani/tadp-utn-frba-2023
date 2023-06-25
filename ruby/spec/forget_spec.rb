describe 'Forget Tests' do
  context 'forget' do
    let(:alejandro){ Person.new }
    after do
      TADB::DB.clear_all
    end
    before do
      class Person
        include Persistence
        has_one String, named: :full_name
        has_one Integer, named: :age
        has_one Boolean, named: :is_regular
      end
    end
    it 'raises error if no id is found' do
      expect{Person.new.forget!}.to raise_error(Persistence::MissingIdError)
    end

    it 'deletes entry' do
      alejandro.full_name = "Alejandro"
      alejandro.age  = 25
      alejandro.is_regular = false
      alejandro.save!

      alejandro.forget!
      expect(alejandro.id).to be(nil)
    end

  end
end
