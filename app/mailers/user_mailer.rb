class UserMailer < ApplicationMailer

  def order_placed(order)
    @order = order
    mail(to: order.employee.email, subject: "Order Placed.")
  end
end
