class ProductsController < ApplicationController

	def index
		@title = 'Meus Produtos'
		@products = Product.all
		@products.order! :name
	end

	def cell
		@title = 'Celulares'
		@products = Product.where "category like ?", "celular"
		@products.order! :name
		render :index
	end

	def eletronic
		@title = 'Eletrônicos'
		@products = Product.where "category like ?", "eletronico"
		@products.order! :name
		render :index
	end

	def part
		@title = 'Peças'
		@products = Product.where "category like ?", 'peca'
		@products.order! :name
		render :index
	end

	def accessory
		@title = 'Acessórios'
		@products = Product.where "category like ?", 'acessorio'
		@products.order! :name
		render :index
	end
	
	def new
		@product = Product.new
		@message = ''
	end

	def create
		@message = ''
		values = params.require(:product).permit!
		sku_registred = Product.all.map{|p| p.sku}
		@product = Product.new values

		if sku_registred.include? @product.sku
			@message = 'SKU já Cadastrado!'
			render :new
		else
			@product.save
			if @product.save
				redirect_to products_path, notice: 'Produto  Criado com Sucesso!'
			else
				@message = 'Campos Obrigatórios não Preenchidos!'
				render :new
			end
		end
	end

	def edit
		@product = Product.find(params[:id])
	end

	def update
		@product = Product.find(params[:id])
		values = params.require(:product).permit!

		@product.update values

		if @product.save
			redirect_to products_path, notice: 'Produto Atualizado com Sucesso!'
		else
			render :edit
		end
	end

	def add
		@product = Product.find(params[:id])
	end

	def entry
		@product = Product.find(params[:id])
		entry = params[:entry]
		entry = entry.to_i
		amount = @product.amount + entry
		@product.update(amount: amount)

		redirect_to product_path(@product), notice: 'Entrada Realizada com Sucesso!'
	end

	def report_products
		@category = params[:category]
		@products = Product.where(category: @category)
		@products = @products.order :amount
	end

	def inventory
		@sales = Sale.all
		@sales = filter_day(@sales)
		@products = []
		@sales.each do |sale|
			sale.item.each do |item|
				if @products.include? item.product
					item.product
				else
					@products << item.product
				end
			end
		end

		respond_to do |format|
			format.html
			format.pdf { render template: 'products/print_inventory', pdf: 'print_inventory'}
		end
	end

	def cost
		cells = Product.where(category: 'celular')
		resume(cells)
		@cells_amount = @products_amount
		@cells_cost = @products_cost
		@cells_price = @products_price

		eletronics = Product.where(category: 'eletronico')
		resume(eletronics)
		@eletronics_amount = @products_amount
		@eletronics_cost = @products_cost
		@eletronics_price = @products_price

		parts = Product.where(category: 'peca')
		resume(parts)
		@parts_amount = @products_amount
		@parts_cost = @products_cost
		@parts_price = @products_price

		accessories = Product.where(category: 'acessorio')
		resume(accessories)
		@accessories_amount = @products_amount
		@accessories_cost = @products_cost
		@accessories_price = @products_price

		all_products = Product.all
		resume(all_products)
		@all_products_amount = @products_amount
		@all_products_cost = @products_cost
		@all_products_price = @products_price

	end

	def destroy
		id = params[:id]
		Product.destroy id
		redirect_to products_path, notice: 'Produto Excluído com Sucesso!'
	end

	def search
		@name = params[:name]
		@products = Product.where "name like ?", "%#{@name}%"
	end

	def show
		@product = Product.find(params[:id])
	end
end

private

	def resume(products)
		@products_amount = 0
		@products_cost = 0
		@products_price = 0
		products.each do |product|
			amount = product.amount
			cost = amount * product.cost
			price = amount * product.price
			@products_amount += amount
			@products_cost += cost
			@products_price += price
		end
		@products_amount
		@products_cost
		@products_price
	end