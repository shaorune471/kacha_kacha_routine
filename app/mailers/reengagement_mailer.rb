class ReengagementMailer < ApplicationMailer
  def reengagement_email(user)
    @user = user
    mail(
      to: user.email,
      subject: "【HabitResteps】また一歩、踏み出してみませんか？"
    )
  end
end
