require "rails_helper"

RSpec.describe ReengagementMailer, type: :mailer do
  describe "#reengagement_email" do
    let(:user) { create(:user, name: "テストユーザー") }
    let(:mail) { ReengagementMailer.reengagement_email(user) }

    it "正しい宛先に送信される" do
      expect(mail.to).to eq([ user.email ])
    end

    it "正しい件名が設定されている" do
      expect(mail.subject).to eq("【HabitResteps】また一歩、踏み出してみませんか？")
    end

    it "本文にユーザー名が含まれている" do
      expect(mail.text_part.body.decoded).to include(user.name)
    end
  end
end
