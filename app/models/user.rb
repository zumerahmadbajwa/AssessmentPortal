class User < ApplicationRecord
  attr_accessor :login
  
  has_many :project_users
  has_many :projects, through: :project_users
  has_many :user_assessments
  has_many :assesments, through: :user_assessments
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :authentication_keys => [:login]

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :username, :email, :password, presence: true, on: :create

  enum role: %i[admin client]

  # username/email validation
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value',
                                    { value: login.downcase }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end
end
