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

	def update
		user = User.find(params[:id])
		password = params[:password]
		if password != ''
			user.update(password: password)
			redirect_to root_path, notice: 'Senha alterada com Sucesso'
		else
			render :edit
		end
	end
end
