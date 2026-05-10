class ContactsController < ApplicationController
  def new
  end

  def create
    name = params[:name]
    email = params[:email]
    message = params[:message]

    response = ContactMailer.new.contact_mail(name, email, message)

    if response.status_code.to_i.between?(200, 299)
      redirect_to contact_path, notice: "お問い合わせを送信しました。"
    else
      Rails.logger.error "SendGrid error: #{response.status_code} #{response.body}"
      flash[:alert] = "送信に失敗しました。時間をおいて再度お試しください。"
      render :new, status: :unprocessable_entity
    end
  end
end
