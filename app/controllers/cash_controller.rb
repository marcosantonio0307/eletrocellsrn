class CashController < ApplicationController

	def index
		@sales = Sale.where(category: 'sale')
		@services = Sale.where(category: 'service')
		@expenses = Expense.all
		cash_sales = filter_day(@sales)
		cash_services = filter_day(@services)
		cash_outflows = filter_day(@expenses)
		@total_cash_sales = 0
		@total_cash_services = 0
		@total_cash_outflows = 0

		if Cash.last != nil
			@begin_value = Cash.last.next_begin
		else
			@begin_value = 200
		end

		cash_sales.each do |cash|
			@total_cash_sales += cash.total
		end

		cash_services.each do |cash|
			@total_cash_services += cash.total
		end

		cash_outflows.each do |cash|
			@total_cash_outflows += cash.total
		end

		@current_cash = @total_cash_sales + @total_cash_services + @begin_value - @total_cash_outflows
		cashes = Cash.all
		@today_cash = filter_day(cashes)
	end

	def new
		total = params[:total]
		@cash = Cash.create(total: total, next_begin: 0)
		redirect_to edit_cash_path(@cash)
	end

	def edit
		@cash = Cash.find(params[:id])
	end

	def update
		@cash = Cash.find(params[:id])
		next_begin = params[:next_begin]
		@cash.update(next_begin: next_begin.to_f)

		redirect_to root_path, notice: 'Caixa Fechado Com Sucesso!'
	end

	def report
		@cashes = Cash.all
	end

	def filter_date
		@cashes = Cash.all
		@begin_date = params[:begin_date]
		@end_date = params[:end_date]

		filter = []

		if @begin_date > @end_date
			render :report
		else
			@cashes.each do |cash|
				if cash.created_at.strftime("%Y-%m-%d") == @begin_date
					filter << cash
				elsif cash.created_at.strftime("%Y-%m-%d") > @begin_date && cash.created_at.strftime("%Y-%m-%d") < @end_date
					filter << cash
				elsif cash.created_at.strftime("%Y-%m-%d") == @end_date
					filter << cash
				end
			end
			@cashes = filter
		end
	end
	
	def reopen
		cashes = Cash.all
		cash = filter_day(cashes)

		if cash != []
			cash.first.destroy
			redirect_to cash_index_path, notice: 'Caixa Reaberto!'
		else
			redirect_to cash_index_path, notice: 'Caixa já esta aberto!'
		end
	end

end
