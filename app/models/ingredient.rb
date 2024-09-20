class Ingredient < ApplicationRecord
  belongs_to :product
  belongs_to :raw_material
end