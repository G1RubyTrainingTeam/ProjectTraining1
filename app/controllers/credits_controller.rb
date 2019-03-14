class CreditsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def new
    @credit = Credit.new
  end

  def create
    @credit = current_user.e_wallet.credits.build credit_params
    if @credit.save
      flash[:success] = t ".success"
      redirect_to e_wallet_path @credit.e_wallet
    else
      flash[:danger] = t ".failure"
      render :new
    end
  end

  def update
    credit = Credit.find_by id: params[:id]
    if credit.present?
      if credit.connected?
        flash[:alert] = t ".existed"
      elsif credit.update connected_params
        flash[:success] = t ".success"
      else
        flash[:danger] = t ".failure"
      end
      redirect_to e_wallet_path credit.e_wallet
    else
      flash[:alert] = t ".credit_nil"
      redirect_to e_wallet_path current_user.e_wallet
    end
  end

  private
  def connected_params
    params.require(:credit).permit :connected
  end

  def credit_params
    params.require(:credit).permit :e_wallet_id, :number, :bank, :card_type,
      :balances, :name, :gender, :date_of_birth, :address, :phone,
      :expiration_date, :email, :employed_by
  end 
end
