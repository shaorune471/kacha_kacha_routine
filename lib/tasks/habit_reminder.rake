namespace :habit_reminder do
  desc "今日の習慣チェックが未完了のユーザーにリマインダーメールを送信"
  task send_emails: :environment do
    User.find_each do |user|
      next if user.habits.empty?
      next if user.habits.all?(&:checked_today?)

      HabitReminderMailer.reminder_email(user).deliver_now
    end
  end
end
