class ExpensesController < ApplicationController

	def expenses
		@expenses = Expense.where(category: 'gerais')
		@report = true
		@title = 'Despesas'
		render :index
	end

	def advances
		@expenses = Expense.where(category: 'vale funcionario')
		@report = true
		@title = 'Vales'
		render :index
	end

	def devolutions
		@expenses = Expense.where(category: 'devolucao')
		@report = true
		@title = 'Devoluções'
		render :index
	end

	def index	
		@expenses = Expense.all
		@title = 'Minhas Despesas'
		@report = false
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
			redirect_to expenses_path, notice: 'Despesa Salva com Sucesso!'
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

	def show
		@expense = Expense.find(params[:id])
	end

	def destroy
		id = params[:id]
		Expense.destroy id
		redirect_to expenses_path, notice: 'Despesa Excluída com Sucesso'
	end
end
