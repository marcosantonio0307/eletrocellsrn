class SalesController < ApplicationController

	def index
		@sales = Sale.all
		@report = false
		@title = 'Vendas'
	end

	def sales
		@sales = Sale.all
		@report = true
		@title = 'Vendas'
		render :index
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

	def filter_date
		@sales = Sale.all
		@begin_date = params[:begin_date]
		@end_date = params[:end_date]
		
		filter(@sale, @begin_date, @end_date)
	end

	def search
		@name = params[:client]
		client = Client.where "name like ?", "%#{@name}%"
		if client.first != nil
			@sales = Sale.where "client_id like ?", "%#{client.first.id}%"
		else
			@sales = []
		end
	end

	def salesman
		id = params[:salesman]
		salesman = User.where(id: id)
		@sales = Sale.where(client_id: id)
		@begin_date = params[:begin_date]
		@end_date = params[:end_date]
		@report = true
		@title = "Vendedor #{salesman.first.email}"

		filter(@sales, @begin_date, @end_date)
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


private

	def filter(sales, begin_date, end_date)
		filter = []

		if @begin_date > @end_date
			render :index
		else
			@sales.each do |sale|
				if sale.created_at.strftime("%Y-%m-%d") == @begin_date
					filter << sale
				elsif sale.created_at.strftime("%Y-%m-%d") > @begin_date && sale.created_at.strftime("%Y-%m-%d") < @end_date
					filter << sale
				elsif sale.created_at.strftime("%Y-%m-%d") == @end_date
					filter << sale
				end
			end
			@sales = filter
		end
	end
