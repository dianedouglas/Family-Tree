require 'active_record'

require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
require 'person'

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
end
