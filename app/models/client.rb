class Client < ApplicationRecord
	validates :name, presence: true
	validates :fone, presence: true

	has_many :sale
end
