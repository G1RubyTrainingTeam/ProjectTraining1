class PayingsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!
  before_action :find_paying, only: :update

  def new
    @paying = Paying.new
  end

  def create
    @paying = current_user.e_wallet.payings.build paying_params
    if current_user.e_wallet.balances > params[:paying][:amount].to_i
      code = ([*("A".."Z"),*("0".."9")]).sample(8).join
      @paying.confirmation_code = code
      @paying.uname = current_user.name
      @paying.uid = current_user.id
      @paying.uemail= current_user.email
      PayingMailer.paying_email(current_user, code).deliver_now if @paying.save
    else
      flash.keep[:alert] = t ".need_payin_alert"
      return
    end
  end

  def edit
  end

  def update
    if !@paying.code_expired?
      @paying.errors.add :base, t(".expired")
      @paying.destroy!
      return
    end
    if @paying.confirmation_code != params[:code]
      @paying.errors.add :base, t(".code_fail")
      return
    end
    paying_update
  end
  
  def show
  end

  private
  
  def paying_params
    params.require(:paying).permit :amount
  end

  def find_paying
    @paying = current_user.e_wallet.payings.find_by id: params[:id]
    flash[:danger] = t(".no_paying") unless @paying
  end

  def paying_update
    amount = @paying.amount
    new_balances_ewallet = current_user.e_wallet.balances - amount
    begin
      ActiveRecord::Base.transaction do
        current_user.e_wallet.update! balances: new_balances_ewallet
        @paying.update! status: 1
        order = current_user.orders.create! total: @total_price, status: 1
        @cart_items.each do |cart_item|
          order.order_details.create! course_id: cart_item.course.id,
            price: cart_item.course.price_sale
        end
        @cart_items.destroy_all
        flash[:success] = t ".success_paying"
      end
    rescue => exception
      @paying.errors.add :base, exception
    end
  end
end
