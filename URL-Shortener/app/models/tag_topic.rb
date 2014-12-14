class TagTopic < ActiveRecord::Base
  validates :tag, presence: true
  validates :short_url_id, presence: true
  
  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :tag_id,
    primary_key: :id
  )
  
  has_many(
    :websites,
    through: :taggings,
    source: :shortened_url
  )
end