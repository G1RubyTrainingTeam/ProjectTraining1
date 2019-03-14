class TransactionsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!
  before_action :find_transaction, only: :update

  def new
    @transaction = Transaction.new
  end

  def create
    code = ([*("A".."Z"),*("0".."9")]).sample(8).join
    @transaction = current_user.e_wallet.transactions.build transaction_params
    @transaction.confirmation_code = code
    PayinMailer.payin_email(current_user, code).deliver_now if @transaction.save
  end

  def edit
  end

  def update
    if @transaction.confirmation_code != params[:code]
      @transaction.errors.add :base, t(".code_fail")
      return
    end
    if !@transaction.code_expired?
      @transaction.errors.add :base, t(".expired")
      return
    end
    if @transaction.credit.expiration_date < Time.now
      @transaction.errors.add :base, t(".credit_expired")
      return
    end
    transaction_update
  end

  private
  
  def transaction_params
    params.require(:transaction).permit :credit_id, :amount, :content
  end

  def find_transaction
    @transaction = current_user.e_wallet.transactions.find_by id: params[:id]
    flash[:danger] = t(".no_transaction") unless @transaction
  end

  def transaction_update
    amount = @transaction.amount
    new_balances_ewallet = current_user.e_wallet.balances + amount
    new_balances_credit = @transaction.credit.balances - amount
    begin
      ActiveRecord::Base.transaction do
        current_user.e_wallet.update! balances: new_balances_ewallet
        @transaction.credit.update! balances: new_balances_credit
        @transaction.update! code_status: 1, transaction_status: 1
        flash[:success] = t ".success_transaction"
      end
    rescue => exception
      @transaction.errors.add :base, exception
    end
  end
end
