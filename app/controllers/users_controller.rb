class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def new
		sign_out
		redirect_to new_user_registration_path
	end

	def edit_user
		@user = current_user
		render :edit
	end

	def edit
		@user = User.find(params[:id])
	end

	def edit_category
		@user = User.find(params[:id])
	end

	def update
		user = User.find(params[:id])
		password = params[:password]
		category = params[:category]
		name = params[:name]
		if password != ''
			if category != nil
				user.update(password: password, category: category, name: name)
				redirect_to root_path, notice: 'Alterado com Sucesso!'
			else
				user.update(password: password)
				redirect_to root_path, notice: 'Alterado com Sucesso!'
			end
		else
			render :edit
		end
	end
end
