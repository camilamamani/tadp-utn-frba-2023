describe 'Persistence Tests' do
  context 'forget' do
    let(:jeep){ Car.new }
    let(:toyota){ Car.new }

    before do
      class Car
        include Persistence
        has_one String, named: :name
        has_one Integer, named: :km
        has_one Boolean, named: :is_4x4
      end
      jeep.name = 'Jeep 23'
      jeep.km = 100
      jeep.is_4x4 = true
      jeep.save!

      toyota.name = 'Toyota Cross'
      toyota.km = 300
      toyota.is_4x4 = true
      toyota.save!
    end

    after do
      TADB::DB.clear_all
    end

    it 'test find by name Jeep 23 ' do
      cars = Car.find_by_name('Jeep 23')
      expect(cars.size).to eq(1)
      expect(cars[0].name).to eq('Jeep 23')
    end

    it 'test find by km 300 ' do
      cars = Car.find_by_km(300)
      expect(cars.size).to eq(1)
      expect(cars[0].name).to eq('Toyota Cross')
    end

    it 'test find by is_4x4 true ' do
      cars = Car.find_by_is_4x4(true)
      expect(cars.size).to eq(2)
    end
  end
end
