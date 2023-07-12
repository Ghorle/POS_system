class Product < ApplicationRecord
    validates :name, uniqueness: true
    has_many_attached :product_images
end
