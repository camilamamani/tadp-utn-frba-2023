describe 'All Instances Tests' do
  context 'all_instances' do
    let(:alejandro){ Cat.new }
    let(:fernando){ Cat.new }

    before do
      class Cat
        include Persistence
        has_one String, named: :name
        has_one Integer, named: :age
        has_one Boolean, named: :is_kitten
        def ==(other)
          self.class == other.class && name == other.name && age == other.age && is_kitten == other.is_kitten
        end
      end

      alejandro.name = "Alejandro"
      alejandro.age  = 5
      alejandro.is_kitten  = true
      alejandro.save!

      fernando.name = "Fernando"
      fernando.age  = 3
      fernando.is_kitten  = true
      fernando.save!

    end

    after do
      TADB::DB.clear_all
    end

    it 'returns all instances of a cats that are saved' do
      expect(Cat.all_instances.size).to eq(2)
    end

    it 'returns all instances of a cats that are saved except the ones forgot' do
      fernando.forget!
      expect(Cat.all_instances.size).to eq(1)
    end

    it 'all instances returned are actual classes and can be updated' do
      cat_a = Cat.all_instances[0]
      cat_a.name = "Cat A"
      cat_a.save!
      expect(Cat.all_instances.include?(cat_a)).to eq(true)
      expect(Cat.all_instances.size).to eq(2)
    end

  end
end
