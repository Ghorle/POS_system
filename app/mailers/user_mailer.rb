class UserMailer < ApplicationMailer

  def order_placed(order)
    @order = order
    mail(to: order.employee.email, subject: "Order Placed.")
  end

  def employee_added(user, password)
    @user = user
    @password = password
    mail(to: user.email, subject: "Please find POS login Credentials attached.")
  end
end
