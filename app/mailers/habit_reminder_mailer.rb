class HabitReminderMailer < ApplicationMailer
  def reminder_email(user)
    @user = user
    @unchecked_habits = user.habits.reject(&:checked_today?)
    mail(
      to: user.email,
      subject: "【HabitResteps】今日の習慣チェックはお済みですか？"
    )
  end
end
