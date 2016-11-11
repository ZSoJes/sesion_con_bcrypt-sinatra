class User < ActiveRecord::Base
  # Remember to create a migration!
  validates :name, :email, :password, presence: true
  validates :email, uniqueness: true

  def self.vacio?(v1, v2, v3)
    if (v1.empty? or v2.empty? or v3.empty?)
      return true
    else 
      return false
    end
  end

  def self.authenticate(email, password)
    User.find_by(email: email, password: password)
  end
end