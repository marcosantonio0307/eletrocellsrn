class ClientsController < ApplicationController

	def index
		@clients = Client.all
	end

	def new
		@client = Client.new
		@message = ''
	end

	def create
		@message = ''
		cpf_registred = Client.all.map{|c| c.cpf}
		values = params.require(:client).permit!

		@client = Client.new values


		if cpf_registred.include?(@client.cpf)
			@message = 'CPF ja cadastrado!'
			render :new
		else
			@client.save
			if @client.save
				redirect_to client_path(@client), notice: 'Cliente Cadastrado com Sucesso!'
			else
				@message = 'Campos Obrigatórios não Preenchidos!'
				render :new
			end
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
