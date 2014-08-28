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

  describe '#capitalize_first_letter' do

    it "will capitalize the first letter of each word in the person's name." do
      @test_person2.capitalize_first_letter
      expect(@test_person2.name).to eq 'Jimmy Page'
    end

    it "will call capitalize_first_letter before saving automatically." do
      expect(@test_person2.name).to eq 'Jimmy Page'
    end
  end

  describe '#validation' do

    it "will validate the presence of a person's name." do
      blank_person = Person.new({})
      expect(blank_person.save).to eq false
    end

    it "will validate the presence of a person's name." do
      blank_person = Person.new({name: 'gnomington'})
      expect(blank_person.save).to eq true
    end
  end

  describe 'default_scope:sort' do

    it 'will order all instances of person alphabetically.' do
      expect(Person.all).to eq [@test_person2, @test_mother1, @test_person1]
    end
  end

  # describe '#siblings' do

  #   it "will output all instances of person with the same mother." do
  #     @test_person1.mother = @test_mother1
  #     @test_person2.mother = @test_mother1
  #     expect(@test_person2.siblings).to eq [@test_person1, @test_person2]
  #     expect(@test_person1.siblings).to eq [@test_person1, @test_person2]
  #   end
  # end

end
