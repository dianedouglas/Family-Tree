class Person < ActiveRecord::Base

  validates :name, :presence => true
  belongs_to :mother, class_name: 'Person'
  has_and_belongs_to_many :locations
  before_save :capitalize_first_letter
  default_scope {order('name')}

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

  def siblings
    siblings = Person.where(mother_id: self.mother_id)
    sibling_array = siblings.to_a
    sibling_array.delete(self)
    sibling_array    
  end
end
