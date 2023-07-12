class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product


  def calc_total_price
    ((price + tax) * qty).round()
  end
end
