require 'spec_helper'

describe Location do

  before do
    setup
  end

  it 'has many people' do
    @test_person1.locations << @test_location
    expect(@test_location.people).to eq [@test_person1]
  end
end
