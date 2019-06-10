class ExpensesController < ApplicationController

	def expenses
		@category = 'gerais'
		@expenses = Expense.where(category: @category)
		@report = true
		@title = 'Despesas'
		render :index
	end

	def advances
		@category = 'vale funcionario'
		@expenses = Expense.where(category: @category)
		@report = true
		@title = 'Vales'
		render :index
	end

	def devolutions
		@category = 'devolucao'
		@expenses = Expense.where(category: @category)
		@report = true
		@title = 'Devoluções'
		render :index
	end

	def index	
		@expenses = Expense.all
		@title = 'Minhas Despesas'
		@report = true
	end

	def new
		@expense = Expense.new
		@category = 'gerais'
	end

	def advance
		@expense = Expense.new
		@category = 'vale funcionario'
	end

	def devolution
		@expense = Expense.new
		@category = 'devolucao'
	end

	def create
		values = params.require(:expense).permit!
		@expense = Expense.create values
		@expense.update(user_id: current_user.id)

		if @expense.save
			redirect_to expenses_expenses_day_path, notice: 'Despesa Salva com Sucesso!'
		end
	end

	def edit
		@expense = Expense.find(params[:id])
	end

	def update
		values = params.require(:expense).permit!
		@expense = Expense.find(params[:id])

		@expense.update values
		redirect_to expense_path(@expense), notice: 'Despesa Alterada com Sucesso!'
	end

	def filter_date
		@category = params[:category]
		@report = true

		if @category != ""
			@expenses = Expense.where(category: @category)
		else
			@expenses = Expense.all
		end

		@begin_date = params[:begin_date]
		@end_date = params[:end_date]
		@filter = []

		if @begin_date > @end_date
			render :index
		else
			@expenses.each do |expense|
				if expense.created_at.strftime("%Y-%m-%d") == @begin_date
					@filter << expense
				elsif expense.created_at.strftime("%Y-%m-%d") > @begin_date && expense.created_at.strftime("%Y-%m-%d") < @end_date
					@filter << expense
				elsif expense.created_at.strftime("%Y-%m-%d") == @end_date
					@filter << expense
				end
			end
			@expenses = @filter
		end
	end

	def expenses_day
		@title = 'Despesas do Dia'
		today = Time.now
		today = today.strftime("%Y-%m-%d")

		@expenses = Expense.where "created_at like ?", "%#{today}%"
	end

	def show
		@expense = Expense.find(params[:id])
	end

	def destroy
		id = params[:id]
		Expense.destroy id
		redirect_to expenses_path, notice: 'Despesa Excluída com Sucesso'
	end
end
