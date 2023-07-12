module FormHelper
  def setup_order(order)
    3.times { order.order_products.build }
    order
  end
end