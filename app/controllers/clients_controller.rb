class ClientsController < ApplicationController

	def index
		@clients = Client.all
	end

	def new
		@client = Client.new
	end

	def create
		values = params.require(:client).permit!
		@client = Client.create values

		if @client.save
			redirect_to client_path(@client), notice: 'Cliente Cadastrado com Sucesso!'
		else
			render :new
		end
	end

	def edit
		@client = Client.find(params[:id])
	end

	def update
		@client = Client.find(params[:id])
		values = params.require(:client).permit!

		@client.update values

		if @client.save
			redirect_to client_path, notice: 'Cliente Altualizado com Sucesso!'
		else
			render :edit
		end

	end

	def destroy
		id = params[:id]
		Client.destroy id
		redirect_to clients_path, notice: 'Cliente Excluído com Sucesso!'
	end

	def search
		@name = params[:name]
		@clients = Client.where "name like ?", "%#{@name}%"
	end

	def show
		@client = Client.find(params[:id])
	end
end
