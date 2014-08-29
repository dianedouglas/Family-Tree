require 'active_record'

require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
require './lib/person'
require './lib/location'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

@current_person = nil
@current_location = nil

def welcome
  puts "\n\nHi! Let's work on your family tree!"
  main_menu
end

def main_menu
  choice = nil
  until choice == 'X'
    puts "\n\n"
    puts "Type [P] to add a new person."
    puts "Type [DP] to delete a person."
    puts "Type [LP] to list all people in the tree."
    puts "Type [EP] to edit a person."
    puts "Type [SO] to add a person's significant other."
    puts "Type [LSO] to print out a person's significant other(s)."
    puts "Type [M] to add a person's mother."
    puts "Type [LS] to print out all of a person's maternal siblings."
    puts "Type [LM] to print out a person's mother's name."
    puts "Type [L] to add a location."
    puts "Type [DL] to delete a location."
    puts "Type [EL] to edit a location."
    puts "Type [LL] to list locations."
    puts "Type [APL] to add a person to a location."
    puts "Type [PL] to print all locations that you could find a particular person in."
    puts "Type [FP] to find all the people that could be in a given location."
    puts "Type [X] to exit."
    choice = gets.chomp.upcase
    case choice
    when 'P'
      create_person
    when 'DP'
      delete_object("Person")
      list_people
    when 'LP'
      list_people
    when 'EP'
      edit_person
    when 'SO'
      puts "First, who got married?"
      select_person
      add_spouse
    when 'LSO'
      list_so
    when 'M'
      add_mother
    when 'LS'
      list_siblings
    when 'LM'
      list_mother
    when 'L'
      add_location
    when 'DL'
      delete_object("Location")
      list_locations
    when 'EL'
      edit_location
    when 'LL'
      list_locations
    when 'APL'
      add_location_to_person
    when 'PL'
      list_person_locations
    when 'FP'
      list_location_people
    when 'X'
      puts "Bye bye!"
    else
      puts "Try again, k? That wasn't an option...\n"
    end
  end
  exit
end

def list_people
  if Person.all.length > 0
    puts "\nHere are all the people you have so far...\n"
    sleep 1
    Person.all.each_with_index do |person, i|
      puts ""
      puts (i + 1).to_s + ". " + person.name
      if person.spouse_id == nil
        puts "Single!"
      else
        puts "Married to: #{person.spouse.name}"
      end
    end
    sleep 1
  else
    puts "You need to add some people first!"
    sleep 1
    main_menu
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

def add_mother
  puts "First, whose mother are you adding?"
  select_person
  puts "Is their mother already in the database? y/n"
  loop do
    yn = gets.chomp
    if yn == 'y'
      child = @current_person
      puts "OK, then let's select their mother."
      select_person
      child.mother = @current_person
      child.save
      puts "\n\nAlright, #{child.name} is the child of #{child.mother.name}"
      break
    elsif yn == 'n'
      puts "OK, then enter the mother's name."
      name = gets.chomp
      mother = Person.create({name: name})
      @current_person.mother = mother
      @current_person.save
      puts "\n\nAlright, #{@current_person.name} is the child of #{@current_person.mother.name}."
      break
    else
      puts "Just enter 'y' or 'n' please."
    end
  end
end

def list_locations
  if Location.all.length > 0
    puts "\nHere are all the locations you have so far...\n"
    sleep 1
    Location.all.each_with_index do |location, i|
      puts ""
      puts (i + 1).to_s + ". " + location.name
    end
    sleep 1
  else
    puts "You need to add some locations first!"
    sleep 1
    main_menu
  end
end

def add_location
  puts "Please enter the name of the location. City, State."
  name = gets.chomp
  @current_location = Location.create({name: name})
  puts "Done."
  list_locations
end

def select_location
  list_locations
  if Location.all.length > 0
    loop do
      puts "Please type in a number to select a location."
      location = gets.chomp.to_i
      if location <= Location.all.length && location > 0
        @current_location = Location.all[location - 1]
        break
      end
    end
  else
    puts "You need to add some locations first!"
    main_menu
  end
end

def add_location_to_person
  puts "Who are we assigning to a location?"
  select_person
  puts "Is the location already in the database? y/n"
  loop do
    yn = gets.chomp
    if yn == 'y'
      puts "OK, then let's select their location."
      select_location
      @current_person.locations << @current_location
      puts "\n\nAlright, #{@current_person.name} is in #{@current_location.name}, at least some of the time."
      break
    elsif yn == 'n'
      puts "OK, then enter the location's name."
      name = gets.chomp
      @current_location = Location.create({name: name})
      @current_person.locations << @current_location
      puts "\n\nAlright, #{@current_person.name} is in #{@current_location.name}, at least some of the time."
      break
    else
      puts "Just enter 'y' or 'n' please."
    end
  end
end

def list_person_locations
  puts "Who are you looking for?"
  select_person
  print_current_person_locations
end

def list_location_people
  puts "Where are you travelling to?"
  select_location
  puts "Perhaps you visit one of these people in #{@current_location.name}: "
  @current_location.people.each do |person|
    puts "\n#{person.name}"
  end
end

def list_siblings
  puts "Who's siblings do you want to see?"
  select_person
  siblings = @current_person.siblings
  if siblings.length > 0
    puts "Here are all the siblings of #{@current_person.name}:"
    siblings.each do |sibling|
      puts "\n#{sibling.name}"
    end
  else
    puts "They don't have any siblings."
  end
end

def delete_object(target_class)
  puts "Which #{target_class} you would like to remove?"
  if target_class == "Location"
    select_location
    @current_location.destroy
  elsif target_class == "Person"
    select_person
    @current_person.destroy
  end
  puts "Done."
end

def edit_person
  puts "Which person would you like to edit?"
  select_person
  choice = nil
  until choice == 'x'
    puts "Enter [n] to edit their name."
    puts "Enter [l] to edit their locations."
    puts "Enter [m] to edit their mother."
    puts "Enter [x] to return to the main menu."
    choice = gets.chomp.downcase
    case choice
  when 'n'
    puts "Enter the new name."
    name = gets.chomp
    @current_person.update({name: name})
  when 'l'
    loop do
      print_current_person_locations
      puts "Enter the location's number to modify it."
      location_index = gets.chomp.to_i
      if location_index > 0 && location_index <= @current_person.locations.length
        @current_location = @current_person.locations[location_index - 1]
        puts "Enter [d] to delete the location, or type in a new name for it."
        modify = gets.chomp
        if modify == 'd' || modify == 'D'
          @current_person.locations.destroy(@current_location)
          print_current_person_locations
          break
        else
          @current_person.locations[location_index - 1].update({name: modify})
          break
        end
      else
        puts "That is not a valid location."
      end
    end
  when 'm'
    if @current_person.mother_id == nil
      puts "#{@current_person.name} doesn't have a mother assigned yet."
      break
    else
      puts "Enter the new name of #{@current_person.name}'s mother, or type [d] to delete her."
      mother = gets.chomp
      if mother == 'd' || mother == 'D'
        @current_person.mother.destroy
      else
        @current_person.mother.update({name: mother})
      end
    end
  when 'x'
    else
      puts 'Afraid that is not an option.'
    end
  end
end

def print_current_person_locations
  puts "Here is #{@current_person.name}'s current list of locations."
  @current_person.locations.each_with_index do |location, i|
    puts "\n#{(i + 1).to_s}. #{location.name}"
  end
end

def edit_location
  select_location
  puts "Enter [d] to delete the location, or type in a new name for it."
  modify = gets.chomp
  if modify == 'd' || modify == 'D'
    @current_location.destroy
    list_locations
  else
    @current_location.update({name: modify})
    list_locations
  end
end

def list_mother
  puts "Who's mother are you looking for?"
  select_person
  if @current_person.mother_id == nil
    puts "They don't have a mother listed yet."
  else
    puts "Their mother is #{@current_person.mother.name}"
  end
end

def list_so
  puts "Who's significant other are you looking for?"
  select_person
  if @current_person.spouse_id == nil
    puts "They don't have a spouse listed yet."
  else
    puts "Their spouse is #{@current_person.spouse.name}"
  end
end

welcome
