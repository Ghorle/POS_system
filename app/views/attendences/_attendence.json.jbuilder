json.extract! attendence, :id, :remark, :type, :status, :user_id, :created_at, :updated_at
json.url attendence_url(attendence, format: :json)
