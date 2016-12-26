class Service < ApplicationRecord
  has_many :statuses, dependent: :destroy
  has_many :outages, dependent: :destroy

  validates_presence_of :name, :url

  validates :url, format: { with: /\A(http:\/\/[a-zA-Z]|https:\/\/)[a-zA-Z]/ }

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
