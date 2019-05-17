class Client < ApplicationRecord
	validates :name, presence: true
	validates :fone, presence: true
end
