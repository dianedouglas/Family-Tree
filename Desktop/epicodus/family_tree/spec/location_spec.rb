require 'spec_helper'

describe Location do

  before do
    setup
  end

  it 'has many people' do
    @test_person1.locations << @test_location
    expect(@test_location.people).to eq [@test_person1]
  end



  describe '#validation' do

    it "will validate the presence of a location's name." do
      blank_location = Location.new({})
      expect(blank_location.save).to eq false
    end

    it "will validate the presence of a location's name." do
      blank_location = Location.new({name: 'Fairy Land'})
      expect(blank_location.save).to eq true
    end
  end
end
