class Like < ActiveRecord::Base

  # add associations
  belongs_to :user
  belongs_to :finstagram_post

  validates_presence_of :user, :finstagram_post

end