class Person < ActiveRecord::Base

  def add_spouse(so)
    self.update({spouse_id: so.id})
    so.update({spouse_id: self.id})
  end

  def spouse
    Person.find(self.spouse_id)
  end

end
