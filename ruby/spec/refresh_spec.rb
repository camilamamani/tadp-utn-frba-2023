describe 'Persistence Tests' do
  context '3. refresh' do
    let(:diana){ Student.new }

    before do
      class Student
        include Persistence
        has_one String, named: :full_name
        has_one Integer, named: :age
      end
    end

    after do
      TADB::DB.clear_all
    end

    it 'refresh da error cuando id es nul' do
      expect{Student.new.refresh!}.to raise_error(Persistence::MissingIdError)
    end

    it 'refresh' do
      diana.full_name = "Diana"
      diana.age  = 25
      diana.save!

      diana.full_name = "Diana Lopez"
      diana.age = 29
      diana.refresh!

      expect(diana.full_name).to eq("Diana")
      expect(diana.age).to eq(25)
    end

  end
end