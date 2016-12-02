class Service < ApplicationRecord
  has_many :statuses
  has_many :outages

  validates_presence_of :name, :url

  scope :active, -> { where(active: true) }
end
