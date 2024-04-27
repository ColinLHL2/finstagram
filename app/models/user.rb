class User < ActiveRecord::Base

  # association methods
  has_many :finstagram_posts
  has_many :comments
  has_many :likes

end