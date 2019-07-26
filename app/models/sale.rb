class Sale < ApplicationRecord
  belongs_to :client
  belongs_to :user

  has_many :item, dependent: :destroy

  def update_total
  	new_total = item.map{|i| i.price}.sum
  	update(total: new_total)
  end
end
