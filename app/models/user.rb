class User < ActiveRecord::Base

  # association methods
  has_many :finstagram_posts
  has_many :comments
  has_many :likes

  # validation methods
  validates(:email, :username, uniqueness: true)
  validates(:email, :username, :avatar_url, :password, presence: true)

end