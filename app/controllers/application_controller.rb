class ApplicationController < ActionController::Base
	before_action :authenticate_user!

	def filter_day(base)
		today = Time.zone.now
		today = today.strftime("%Y-%m-%d")
		filter = []
		base.each do |b|
			if b.created_at.strftime("%Y-%m-%d") == today
				filter << b
			end
		end
		base = filter
		base.sort!
	end
end
