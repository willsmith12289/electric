class Post < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_posts, against: {
    title: 'A',
    body: 'B'
  }, using: { tsearch: { prefix: true } }

  mount_uploader :image, ImageUploader
  
  has_many :comments, dependent: :destroy
  validates :title, presence: true, length: {minimum: 5}
  validates :body, presence: true
  validates :image, presence: true
end
