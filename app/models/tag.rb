class Tag < ApplicationRecord
  # has_and_belongs_to_many :posts
  has_many :taggings
  has_many :posts, through: :taggings
end
