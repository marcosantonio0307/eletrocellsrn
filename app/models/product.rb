class Product < ApplicationRecord
	validates :name, presence: true
	validates :amount, presence: true
	validates :cost, presence: true
	validates :price, presence: true
end
