class Product < ApplicationRecord
  has_many :ingredients, dependent: :destroy
  has_many :raw_materials, through: :ingredients

  validates :name, uniqueness: true
  has_many_attached :product_images

  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
end
