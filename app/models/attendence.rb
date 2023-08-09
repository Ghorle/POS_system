class Attendence < ApplicationRecord
  belongs_to :user


  scope :current_days, -> {
    date_time_from = Time.zone.parse("#{Date.today.strftime('%Y-%m-%d')} 9:00")
    date_time_to = Time.zone.parse("#{Date.today.strftime('%Y-%m-%d')} 23:59")
  
    where(created_at: (date_time_from..date_time_to))
  }
end
