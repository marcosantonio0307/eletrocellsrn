class Sale < ApplicationRecord
  belongs_to :client
  belongs_to :user

  has_many :item, dependent: :destroy
end
