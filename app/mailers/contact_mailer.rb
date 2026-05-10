class ContactMailer < ApplicationMailer
  def contact_mail(name, email, message)
    @name = name
    @email = email
    @message = message

    mail(
      to: ENV["CONTACT_MAIL_ADDRESS"],
      from: ENV["CONTACT_MAIL_ADDRESS"],
      reply_to: email,
      subject: "【HabitResteps】お問い合わせがありました"
    )
  end
end
