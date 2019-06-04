module ApplicationHelper
	def admin?(user)
		if user.category == 'admin'
			true
		end
	end
end
