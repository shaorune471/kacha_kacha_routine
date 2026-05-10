class ContactsController < ApplicationController
  def new
  end

  def create
    name = params[:name]
    email = params[:email]
    message = params[:message]

    ContactMailer.contact_mail(name, email, message).deliver_now
    redirect_to contact_path, notice: "お問い合わせを送信しました。"
  rescue => e
    Rails.logger.error "ContactMailer error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    flash[:alert] = "送信に失敗しました。時間をおいて再度お試しください。"
    render :new, status: :unprocessable_entity
  end
end
