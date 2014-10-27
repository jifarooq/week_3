class Tagging < ActiveRecord::Base
  validates :tag_id, presence: true
  validates :short_url_id, presence: true
  
  belongs_to(
    :tag,
    class_name: 'TagTopic',
    foreign_key: :short_url_id,
    primary_key: :id
  )
  
  belongs_to(
    :website,
    class_name: 'ShortenedUrl',
    foreign_key: :short_url_id,
    primary_key: :id
  )
end