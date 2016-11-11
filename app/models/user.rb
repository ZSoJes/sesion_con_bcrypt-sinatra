class User < ActiveRecord::Base
include BCrypt
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

  def self.authenticate(email, user_password)
    user = User.find_by(email: email)
    if user && (user.password == user_password)
      return user
    else
      nil
    end
  end

  def password
    @password ||= Password.new(password_digest)
  end

  def password=(user_password)
    @password = Password.create(user_password)
    self.password_digest = @password
  end

end