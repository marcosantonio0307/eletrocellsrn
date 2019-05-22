class ItemsController < ApplicationController
	def new
		@sale = Sale.find(params[:sale_id])
		sku = params[:sku]
		item = Product.where "sku like ?", "%#{sku}%"

		if item.first.amount > 0
			@item = Item.create
			@item.update(sale: @sale, product: item.first)
		else
			redirect_to edit_sale_path(@sale), notice: 'Produto com Estoque Zerado!'
		end
	end

	def add
		@sale = Sale.find(params[:sale_id])
		@item = Item.find(params[:id])

		amount = params[:amount]
		amount = amount.to_i
		unity = @item.product.price
		price = unity * amount
		total = @sale.total
		total += price

		@sale.update(total: total)
		@item.update(amount: amount, price: price)

		new_amount = @item.product.amount - amount
		@item.product.update(amount:  new_amount)

		redirect_to edit_sale_path(@sale)
	end

	def destroy
		@sale = Sale.find(params[:sale_id])
		id = params[:id]
		item = Item.find(id)

		amount = item.amount #retorna a quantidade do produto para o estoque quando remove-o da lista
		new_amount = item.product.amount + amount
		item.product.update(amount: new_amount)

		price = item.price #atualiza o valor da venda sem o item removido
		new_total = @sale.total - price
		@sale.update(total: new_total)

		Item.destroy id
		redirect_to edit_sale_path(@sale)
	end
end
