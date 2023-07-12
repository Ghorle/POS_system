module ApplicationHelper
  def from_products
    products = []
    Product.all.each do |product|
      products = products + [[product.name, product.id]]
    end
    products
  end
  def no_to_rupees(number)
    number = number.to_s
    rs = ""
    number.reverse.chars.each_with_index{|i, index| rs<<i; rs<<"," if index==2; rs<<"," if (index!=number.chars.count-1&&index>3&&index%2==0) }
    rs = rs.reverse
    return rs
  end
  
end
