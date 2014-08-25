require 'active_record'

require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
require './lib/person'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

@current_person = nil

def welcome
  puts "\n\nHi! Let's work on your family tree!"
  main_menu
end

def main_menu
  choice = nil
  until choice == 'X'
    puts "\n\n"
    puts "Type [P] to add a new person."
    puts "Type [LP] to list all people in the tree."
    puts "Type [SO] to add a person's significant other."
    puts "Type [X] to exit."
    choice = gets.chomp.upcase
    case choice
    when 'P'
      create_person
    when 'LP'
      list_people
    when 'SO'
      puts "First, who got married?"
      select_person
      add_spouse
    when 'X'
      puts "Bye bye!"
    else
      puts "Try again, k? That wasn't an option...\n"
    end
  end
  exit
end

def list_people
  puts "\nHere are all the people you have so far...\n"
  Person.all.each_with_index do |person, i|
    puts ""
    puts (i + 1).to_s + ". " + person.name
    if person.spouse_id == nil
      puts "Single!"
    else
      puts "Married to: #{person.spouse.name}"
    end
    sleep 1
  end
end

def create_person
  puts "Please enter the person's full name."
  name = gets.chomp
  @current_person = Person.create({name: name})
  list_people
end

def select_person
  list_people
  if Person.all.length > 0
    loop do
      puts "Please type in a number to select a person."
      person = gets.chomp.to_i
      if person <= Person.all.length && person > 0
        @current_person = Person.all[person - 1]
        break
      end
    end
  else
    puts "You need to add some people first!"
    main_menu
  end
end

def add_spouse
  puts "Please enter the name of #{@current_person.name}'s new spouse."
  spouse_name = gets.chomp
  spouse = Person.create({name: spouse_name})
  @current_person.add_spouse(spouse)
  @current_person.save
  puts "\n\n Congratulations to #{@current_person.name} and #{@current_person.spouse.name}!!"
  main_menu
end


welcome
