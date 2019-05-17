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
	end

	def create
		values = params.require(:product).permit!
		@product = Product.create values

		if @product.save
			redirect_to product_path(@product), notice: 'Produto  Criado com Sucesso!'
		else
			redirect_to new_product_path, notice: 'Campos Obrigatórios não preenchidos!'
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
