class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  validates_length_of :title, minimum:10, allow_blank: true,
   message: 'title is too short!'
  validates :image_url, allow_blank: true, format: {
    with: /\.(gif|png|jpg)\Z/,
    message: 'URL must be gif, jpg or png'
  }
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  # ensure line items are not referenced by any product
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line items present')
      throw :abort
    end
  end
end
