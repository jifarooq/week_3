class ShortenedUrl < ActiveRecord::Base
  validates :short_url, presence: true, uniqueness: true
  validates :submitter_id, presence: true
  
  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id
  )
  
  has_many(
    :visits,         #goes through THIS!
    class_name: 'Visit',
    foreign_key: :short_url_id,
    primary_key: :id
  )
  
  has_many(
    :visitors,
    through: :visits,
    source: :user
  )
  
  has_many(
    :uniq_visitors,
    Proc.new { distinct },
    through: :visits,
    source: :user
  )
  
  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :short_url_id,
    primary_key: :id
  )
  
  has_many(
    :tags,
    through: :taggings,
    source: :tag_topic
  )
  
  def self.random_code
    short_url = SecureRandom.base64
    while ShortenedUrl.exists?(short_url: short_url)
      short_url = SecureRandom.base64
    end
    p short_url
  end
  
  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(long_url: long_url, short_url: self.random_code, 
    submitter_id: user.id)
  end
  
  def num_clicks
    self.visits.count
  end
  
  def num_uniques
    # self.visits.select(:user_id).distinct.count
    self.uniq_visitors.count
  end
  
  def num_recent_uniques #in a recent time period
    visits
      .where('updated_at >= ?', 10.minutes.ago)
      .distinct
      .count
  end
  
end