class Product < ActiveRecord::Base
  include SearchCop
  mount_uploader :image, ImageUploader
  search_scope :search do
    attributes :title, :description, :category
  end
  
  has_many :line_items, dependent: :destroy

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, presence: true
  # validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true

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
