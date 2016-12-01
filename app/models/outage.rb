class Outage < ApplicationRecord
  belongs_to :service

  validates_presence_of :service_id, :codes
end
