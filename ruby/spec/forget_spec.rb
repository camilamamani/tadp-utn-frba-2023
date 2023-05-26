describe 'Persistence Tests' do
  context 'forget' do
    let(:alejandro){ Student.new }

    before do
      class Student
        include Persistence
        has_one String, named: :full_name
        has_one Integer, named: :age
        has_one Boolean, named: :is_regular
      end
    end

    after do
      TADB::DB.clear_all
    end
    it 'raises error if no id is found' do
      expect{Student.new.forget!}.to raise_error(Persistence::MissingIdError)

    end

    it 'deletes entry' do
      alejandro.full_name = "Alejandro"
      alejandro.age  = 25
      alejandro.save!

      alejandro.forget!
      expect(alejandro.id).to be(nil)
    end

  end
end
