module CalculationConcern
  extend ActiveSupport::Concern

  included do
    after_save :set_amounts
  end

  def set_amounts
    total_amount = 0
    self.order_products.each do |order_product|
      if order_product.price.present?
        total_amount += order_product.calc_total_price
      end
    end
    
    self.discount = total_amount

    # WARNING: Don't use any method that will trigger an after_save callback. Infinite loop otherwise.
    self.update_columns(discount: total_amount.round())
  end
end