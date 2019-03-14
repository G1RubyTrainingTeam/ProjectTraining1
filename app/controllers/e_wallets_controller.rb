class EWalletsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def create
    if current_user.e_wallet.nil?
      e_wallet = current_user.build_e_wallet
      if e_wallet.save
        flash[:success] = t "create_success"
        redirect_to e_wallet_path e_wallet
      else
        flash[:danger] = t "create_failed"
      end
    end
  end

  def show
    @e_wallet = current_user.e_wallet
    @approved_credits = current_user.e_wallet.credits.approved
    if params[:number]
      @credit = Credit.find_by id: params[:number]
    end
  end
end
