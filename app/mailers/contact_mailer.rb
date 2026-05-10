class ContactMailer < ApplicationMailer
  def contact_mail(name, email, message)
    @name = name
    @email = email
    @message = message

    sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])

    from = SendGrid::Email.new(email: ENV["CONTACT_MAIL_ADDRESS"])
    to = SendGrid::Email.new(email: ENV["CONTACT_MAIL_ADDRESS"])
    subject = "【HabitResteps】お問い合わせがありました"

    content = SendGrid::Content.new(
      type: "text/plain",
      value: "お名前：#{name}\nメールアドレス：#{email}\nお問い合わせ内容：\n#{message}"
    )

    mail = SendGrid::Mail.new(from, subject, to, content)
    mail.reply_to = SendGrid::Email.new(email: email)

    sg.client.mail._("send").post(request_body: mail.to_json)
  end
end
