describe 'Persistence Tests' do
  context '2. save' do
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

    it 'Un estudiante responde a id' do
      alejandro.full_name = "Alejandro"
      alejandro.age  = 25
      alejandro.is_regular = true
      alejandro.save!

      expect(alejandro).to respond_to(:id)
    end

  end
end