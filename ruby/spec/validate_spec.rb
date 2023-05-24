describe 'Persistence Tests' do
  context 'validate' do
    let(:alejandro){ Student.new }
    before do
      class Student
        include Persistence
        has_one String, named: :full_name, no_blank: true, from: 8
        has_one Integer, named: :age
        has_one Boolean, named: :is_regular
      end

    end

    after do
      TADB::DB.clear_all
    end

    it 'Validate da error si campo full_name es numero' do
      alejandro.full_name = 55
      expect{alejandro.save!}.to raise_error(PersistentAttribute::TypeError)
    end

    it 'Validate da TypeError si campo es no_blank true' do
      alejandro.full_name = ""
      expect{alejandro.save!}.to raise_error(PersistentAttribute::TypeError)
    end
  end
end