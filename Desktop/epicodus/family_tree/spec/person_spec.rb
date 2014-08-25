require 'spec_helper'

describe Person do
  before do
    setup
  end

  describe '#initialize' do

    it 'instantiates a person inheriting from ActiveRecord.' do
      expect(@test_person1).to be_an_instance_of Person
    end

    it 'should have attributes for name, id and spouse_id' do
      expect(@test_person1.name).to eq 'Robert Plant'
    end
  end

  describe '#add_spouse, #spouse' do

    it "sets and returns the person's spouse." do
      @test_person1.add_spouse(@test_person2)
      expect(@test_person1.spouse).to eq @test_person2
      expect(@test_person2.spouse).to eq @test_person1
    end
  end

  describe '#mother' do

    it "has one mother." do
      @test_person1.mother = @test_mother1
      expect(@test_person1.mother).to eq @test_mother1
    end
  end

  describe '#locations' do

    it "has many locations (home, vacation home, college, etc.)" do
      @test_person1.locations << @test_location
      expect(@test_person1.locations).to eq [@test_location]
    end
  end
end
