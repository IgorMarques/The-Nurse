class Status < ApplicationRecord
  belongs_to :service

  validates_presence_of :code
end
