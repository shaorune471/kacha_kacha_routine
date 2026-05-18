require "rails_helper"

RSpec.describe HabitReminderMailer, type: :mailer do
  describe "#reminder_email" do
    let(:user) { create(:user, name: "テストユーザー") }
    let(:habit) { create(:habit, user: user) }
    let(:mail) { HabitReminderMailer.reminder_email(user) }

    it "正しい宛先に送信される" do
      expect(mail.to).to eq([ user.email ])
    end

    it "正しい件名が設定されている" do
      expect(mail.subject).to eq("【HabitResteps】今日の習慣チェックはお済みですか？")
    end

    it "本文にユーザー名が含まれている" do
      expect(mail.text_part.body.decoded).to include(user.name)
    end

    it "未チェックの習慣が本文に含まれている" do
      habit
      expect(mail.text_part.body.decoded).to include(habit.title)
    end
  end
end
