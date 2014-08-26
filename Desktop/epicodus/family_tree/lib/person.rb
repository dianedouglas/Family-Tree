class Person < ActiveRecord::Base

  belongs_to :mother, class_name: 'Person'
  has_and_belongs_to_many :locations
  before_save :capitalize_first_letter

  def add_spouse(so)
    self.update({spouse_id: so.id})
    so.update({spouse_id: self.id})
  end

  def spouse
    Person.find(self.spouse_id)
  end

  def capitalize_first_letter
  	new_name = self.name
  	new_name = new_name.split(" ")
  	new_name.each_with_index {|word, i| new_name[i] = word[0].upcase + word[1..word.length]}
  	new_name = new_name.join(" ")
  	self.name = new_name
  end
end
