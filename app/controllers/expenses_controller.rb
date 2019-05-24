class ExpensesController < ApplicationController

	def index	
		@expenses = Expense.all
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
end
