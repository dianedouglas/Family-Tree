require 'active_record'

require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
require 'person'
require 'location'

database_configurations = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configurations['test']
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
  config.after(:each) do
    #Class.all.each {|class| class.destroy}
  	Person.all.each {|person| person.destroy}
  end
end

def setup
  @test_person1 = Person.new({name: 'Robert Plant'})
  @test_person1.save
  @test_person2 = Person.new({name: 'Jimmy Page'})
  @test_person2.save
  @test_mother1 = Person.new({name: 'Mrs. Plant'})
  @test_mother1
  @test_location = Location.new({name: 'Portland, OR'})
  @test_location.save
end
