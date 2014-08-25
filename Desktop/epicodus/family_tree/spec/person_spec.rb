require 'spec_helper'

describe Person do
  before do
    setup
  end

  it 'instantiates a person inheriting from ActiveRecord.' do
    expect(@test_person1).to be_an_instance_of Person
  end

  it 'should have attributes for name, id and spouse_id' do
    expect(@test_person1.name).to eq 'Robert Plant'
  end
end
