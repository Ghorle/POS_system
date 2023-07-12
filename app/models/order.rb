class Order < ApplicationRecord
  include CalculationConcern
  
  belongs_to :employee, class_name: "User"
  has_many   :order_products, dependent: :destroy

  accepts_nested_attributes_for :order_products, reject_if: :all_blank, allow_destroy: true

  enum status: {
    on_going: 0,
    hold: 1,
    ready: 2,
    closed: 3
  }
  scope :on_goings, -> {where(status: "on_going")}
  scope :ready, -> {where(status: "ready")}
  scope :closeds, -> {where(status: "closed")}
  scope :current_days, -> {
    date_time_from = Time.zone.parse("#{Date.today.strftime('%Y-%m-%d')} 9:00")
    date_time_to = Time.zone.parse("#{Date.today.strftime('%Y-%m-%d')} 23:30")
  
    where(created_at: (date_time_from..date_time_to))
  }

  def update_order_details
    gross_total = 0 
    tax = 0
    order_products.each do |oproduct|
      oproduct.update!(name: oproduct&.product&.name, description: oproduct&.product&.description, price: oproduct&.product&.price, tax: (5*(oproduct&.product&.price).to_f/100))
      product_price = oproduct.price.to_f*oproduct.qty.to_f
      oproduct.update!(amount: product_price)
      gross_total += product_price
      tax += oproduct.tax.to_f*oproduct.qty.to_f
    end 

    self.update!(gross_total: gross_total&.round(2), tax: tax&.round(2), discount: 0, payable_total: (gross_total.to_f + tax.to_f)&.round(2))
  end 

end
