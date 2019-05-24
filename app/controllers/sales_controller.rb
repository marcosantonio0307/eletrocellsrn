class SalesController < ApplicationController

	def index
		@sales = Sale.all	
	end

	def new
		@sale = Sale.new
		if Sale.last != nil
			last_id = Sale.last.id
			@sale.id = (last_id + 1)
		else
			@sale.id = 1
		end
		@sale.client_id = 1
		@sale.user_id = current_user.id
		@sale.total = 0
		@sale.save
		redirect_to client_sale_path(@sale)
	end

	
	def select
		@sale = Sale.find(params[:id])
		@cpf = params[:cpf]

		if @cpf.empty?
			render :client
		else
			client = Client.where "cpf like ?", "%#{@cpf}%"
			if client.empty?
				render :client
			else
				@sale.update(client_id: client.first.id)
				redirect_to edit_sale_path(@sale)
			end
		end
	end

	def edit
		@sale = Sale.find(params[:id])
		@items = Item.where(sale_id: @sale.id)
	end

	def update
		@sale = Sale.find(params[:id])
		redirect_to sale_path(@sale), notice: 'Venda Salva com Sucesso!'
	end

	def destroy
		id = params[:id]
		Sale.destroy id
		redirect_to sales_path, notice: 'Venda Excluída com Sucesso!'
	end

	def show
		@sale = Sale.find(params[:id])
		@items = Item.where(sale_id: @sale.id)
	end
end
