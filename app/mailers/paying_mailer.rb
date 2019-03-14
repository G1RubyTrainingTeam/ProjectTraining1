class PayingMailer < ApplicationMailer
  def paying_email user, code
    @user = user
    @code = code
    mail to: @user.email, subject: t(".subject")
  end
end
