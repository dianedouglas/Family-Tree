class Person < ActiveRecord::Base

  def add_spouse(so)
    self.update({spouse_id: so.id})
  end

  def spouse
    Person.find(self.spouse_id)
  end

end
