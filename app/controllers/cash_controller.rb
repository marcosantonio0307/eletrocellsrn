class CashController < ApplicationController

	def index
		today = Time.zone.now
		today = today.strftime("%Y-%m-%d")
		cash_receipts = Sale.where "created_at like ?", "%#{today}%"
		cash_outflows = Expense.where "created_at like ?", "%#{today}%"
		@total_cash_receipts = 0
		@total_cash_outflows = 0

		if Cash.last != nil
			@begin_value = Cash.last.next_begin
		else
			@begin_value = 200
		end
		

		cash_receipts.each do |cash|
			@total_cash_receipts += cash.total
		end

		cash_outflows.each do |cash|
			@total_cash_outflows += cash.total
		end

		@current_cash = @total_cash_receipts + @begin_value - @total_cash_outflows
		@today_cash = Cash.where "created_at like ?", "%#{today}%"
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
		today = Time.zone.now
		today = today.strftime("%Y-%m-%d")
		cash = Cash.where "created_at like ?", "%#{today}%"

		if cash != []
			cash.first.destroy
			redirect_to cash_index_path, notice: 'Caixa Reaberto!'
		else
			redirect_to cash_index_path, notice: 'Caixa já esta aberto!'
		end
	end

end
