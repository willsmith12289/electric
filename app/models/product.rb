class Product < ActiveRecord::Base
  include SearchCop

  search_scope :search do
    attributes :title, :description, :category
  end
  
  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    messaage: 'must be a url for GIF, JPG or PNG image.'
  }, :allow_blank => true

  def self.latest
    Product.order(:updated_at).last
  end

  # def self.search(search)
  #   where("title like ? OR description like ? OR category like ?", "#{search}", "#{search}", "#{search}")
  # end

  private

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items Present')
      return false
    end
  end
end
