class Person < ActiveRecord::Base

  belongs_to :mother, class_name: 'Person'

  def add_spouse(so)
    self.update({spouse_id: so.id})
    so.update({spouse_id: self.id})
  end

  def spouse
    Person.find(self.spouse_id)
  end

end
