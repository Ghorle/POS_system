json.extract! order, :id, :customer_name, :customer_contact, :order_type, :created_at, :updated_at
json.url order_url(order, format: :json)
