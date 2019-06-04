class SalesController < ApplicationController

	def index
		@sales = Sale.where(category: 'sale')
		@report = false
		@title = 'Vendas'
	end

	def services
		@sales = Sale.where(category: 'service')
		@report = false
		@title = 'Ordens de Serviço'
		render :index
	end

	def opens
		@sales = Sale.where(category: 'service', status: 'aberta')
		@report = false
		@title = 'O.S Abertas'
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
		@sale.category = 'sale'
		@sale.status = 'fechada'
		@sale.description = ''
		@sale.save
		redirect_to client_sale_path(@sale)
	end

	def new_service
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
		@sale.category = 'service'
		@sale.status = 'aberta'
		@sale.description = ''
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
		description = params[:description]
		status = params[:status]
		@sale.update(description: description, status: status)
		redirect_to sales_path, notice: 'Venda Salva com Sucesso!'
	end

	def finish
		@sale = Sale.find(params[:id])
		@sale.update(status: 'fechada')
		redirect_to sales_services_path, notice: 'O.S finalizada com Sucesso!'
	end

	def filter_date
		category = params[:category]
		@sales = Sale.where(category: category)
		@begin_date = params[:begin_date]
		@end_date = params[:end_date]
		
		filter(@sales, @begin_date, @end_date)
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

	def report_salesman
		@title = 'Relatório por Vendedor'
		@begin_date = params[:begin_date]
		@end_date = params[:end_date]
		@sellers = User.all
		@sales = Sale.where(category: 'sale')
		filter(@sales, @begin_date, @end_date)
	end

	def report_commission
		id = params[:salesman]
		salesman = User.where(id: id)
		@sales = Sale.where(user_id: id, category: 'sale')
		@begin_date = params[:begin_date]
		@end_date = params[:end_date]
		@percentage = params[:commission]
		@percentage = @percentage.to_f
		@report = true
		@title = "Vendedor: #{salesman.first.email}"

		filter(@sales, @begin_date, @end_date)

		@commission = 0
		@sales.each do |sale|
			sale.item.each do |item|
				if item.product.category != 'celular'
					@commission += item.price
				end
			end
		end
		
		@commission = @commission * (@percentage/100)
	end

	def sales_day
		@title = 'Vendas do Dia'
		@report = false
		today = Time.now
		today = today.strftime("%Y-%m-%d")
		@sales = Sale.where(category: 'sale')
		@sales = @sales.where "created_at like ?", "%#{today}%"
	end

	def services_day
		@title = 'O.S do Dia'
		@report = false
		today = Time.now
		today = today.strftime("%Y-%m-%d")
		@sales = Sale.where(category: 'service')
		@sales.where "created_at like ?", "%#{today}%"

		render :sales_day
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

		if begin_date > end_date
			render :index
		else
			sales.each do |sale|
				if sale.created_at.strftime("%Y-%m-%d") == begin_date
					filter << sale
				elsif sale.created_at.strftime("%Y-%m-%d") > begin_date && sale.created_at.strftime("%Y-%m-%d") < end_date
					filter << sale
				elsif sale.created_at.strftime("%Y-%m-%d") == end_date
					filter << sale
				end
			end
			sales = filter
		end
	end
