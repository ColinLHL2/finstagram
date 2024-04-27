class Comment < ActiveRecord::Base

  # add associations
  belongs_to :user
  belongs_to :finstagram_post

end