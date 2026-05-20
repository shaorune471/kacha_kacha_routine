namespace :reengagement do
  desc "2週間以上チェックがないユーザーに再開サポートメールを送信"
  task send_emails: :environment do
    two_weeks_ago = 14.days.ago.to_date

    User.find_each do |user|
      next if user.habits.empty?
      next unless user.reengagement_notification?

      latest_check = HabitCheck
        .joins(:habit)
        .where(habits: { user_id: user.id })
        .maximum(:checked_on)

      next if latest_check.nil?
      next if latest_check > two_weeks_ago

      ReengagementMailer.reengagement_email(user).deliver_now
    end
  end
end
