class ItemsController < ApplicationController
	def new
		@sale = Sale.find(params[:sale_id])
		sku = params[:sku].strip
		item = Product.where "sku like ?", "%#{sku}%"

		if item.first.amount > 0
			@item = Item.create
			@item.update(sale: @sale, product: item.first)
		else
			redirect_to edit_sale_path(@sale), notice: 'Produto com Estoque Zerado!'
		end
	end

	def new_select
		@sale = Sale.find(params[:sale_id])
		product = Product.find(params[:id])
		if product.amount > 0
			@item = Item.create
			@item.update(sale: @sale, product: product)
		else
			redirect_to edit_sale_path(@sale), notice: 'Produto com Estoque Zerado!'
		end
	end

	def add
		@sale = Sale.find(params[:sale_id]) #set
		@item = Item.find(params[:id])

		amount = params[:amount] 
		amount = amount.to_i
		unity = @item.product.price
		discount = params[:discount]
		discount = discount.to_f
		price = unity - discount
		price = price * amount
		total = @sale.total
		total += price

		@sale.update(total: total)
		@item.update(amount: amount, price: price, discount: discount)

		new_amount = @item.product.amount - amount
		@item.product.update(amount:  new_amount)

		redirect_to edit_sale_path(@sale), notice: 'Item Incluído com Sucesso!'
	end

	def destroy
		@sale = Sale.find(params[:sale_id])
		id = params[:id]
		item = Item.find(id)

		if item.amount != nil
			amount = item.amount #retorna a quantidade do produto para o estoque quando remove-o da lista
			new_amount = item.product.amount + amount
			item.product.update(amount: new_amount)
		end

		if item.price != nil
			price = item.price #atualiza o valor da venda sem o item removido
			new_total = @sale.total - price
			@sale.update(total: new_total)
		end

		Item.destroy id
		redirect_to edit_sale_path(@sale)
	end
end
