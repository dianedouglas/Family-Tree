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
    end
  end
end
