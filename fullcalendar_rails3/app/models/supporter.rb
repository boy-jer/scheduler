class Supporter < ActiveRecord::Base
  
  validates :email, :presence => true, :uniqueness => true, :email_format => true
  validates :phone, :presence => true, :phone_format => true
  validates :name,  :role, :presence => true
 # validates_inclusion_of :isIT, :in => [true, false]
 
  
  has_many :events
  
  def self.devs
   # where(:isIT => false)
    where(:role => "Developer")
  end
  
  def self.its
    # where(:isIT => true)
    where(:role => "IT Personnel")
  end
  
  def isDev?
    if self.role == "Developer"
      true
    else
      false
    end
  end
  
  def self.notice
    time_range = Date.today + 1.week
    Supporter.joins(:events).where(:events => {:startDate => time_range})
  end

end
