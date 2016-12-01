class Service < ApplicationRecord
  has_many :statuses

  validates_presence_of :name, :url

  scope :active, -> { where(active: true) }
end
