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
