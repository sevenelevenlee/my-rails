class Post < ApplicationRecord
  validates :title, :presence => true, :uniqueness => true
  validates :content, :presence => true

  has_many :comments
  has_many :attachments, as: :attachmentable
  # has_and_belongs_to_many :tags
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :user

  scope :tag_with, lambda {|tag_name| joins(:tags).where("tags.name = ?", tag_name)}
  scope :latter_than, lambda {|time| joins(:taggings).where("taggings.created_at > ?", time)}

  #所有tag的posts
  # def self.with_tag(tag_name)
  #   Tag.find_by_name(tag_name).try(:posts)
  # end
end
