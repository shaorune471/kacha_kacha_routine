require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "名前・メール・パスワードが必須" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "メールアドレスが重複している場合は無効" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).not_to be_valid
    end
  end

  describe "習慣ポイントの計算" do
    it "全ての習慣ポイントの合計を返す" do
      user = create(:user)
      habit1 = create(:habit, user: user)
      habit2 = create(:habit, user: user)
      create(:habit_check, habit: habit1, checked_on: Date.today - 1, evaluation: :all_achieved)
      create(:habit_check, habit: habit2, checked_on: Date.today - 1, evaluation: :minimum_achieved)
      expect(user.total_experience).to eq(2)
    end
  end

  describe ".from_omniauth" do
    def auth_hash(uid: "123456", email: "google@example.com", name: "Googleユーザー")
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: uid,
        info: OmniAuth::AuthHash::InfoHash.new(email: email, name: name)
      )
    end

    context "該当するprovider・uidのユーザーが存在しない場合" do
      it "新しいユーザーを作成する" do
        expect { User.from_omniauth(auth_hash) }.to change(User, :count).by(1)
      end

      it "認証情報からemail・nameを設定する" do
        user = User.from_omniauth(auth_hash(email: "google@example.com", name: "Googleユーザー"))
        expect(user.email).to eq("google@example.com")
        expect(user.name).to eq("Googleユーザー")
      end

      it "provider・uidを保存する" do
        user = User.from_omniauth(auth_hash(uid: "123456"))
        expect(user.provider).to eq("google_oauth2")
        expect(user.uid).to eq("123456")
      end

      it "作成されたユーザーは永続化されている" do
        user = User.from_omniauth(auth_hash)
        expect(user).to be_persisted
      end
    end

    context "該当するprovider・uidのユーザーがすでに存在する場合" do
      it "既存のユーザーを返し、新規作成しない" do
        existing_user = create(:user, provider: "google_oauth2", uid: "123456")
        expect {
          user = User.from_omniauth(auth_hash(uid: "123456"))
          expect(user).to eq(existing_user)
        }.not_to change(User, :count)
      end
    end

    context "取得した情報が不正でユーザーを保存できない場合" do
      it "永続化されていないユーザーを返す" do
        user = User.from_omniauth(auth_hash(name: ""))
        expect(user).not_to be_persisted
        expect(user.errors).not_to be_empty
      end
    end
  end

  describe "#update_with_password_check" do
    context "Googleアカウントで登録し、まだパスワードを設定していないユーザーの場合" do
      let(:user) { create(:user, provider: "google_oauth2", uid: "123456", password_set: false) }

      it "現在のパスワードなしでパスワードを設定できる" do
        result = user.update_with_password_check(
          { "password" => "newpassword", "password_confirmation" => "newpassword" }.with_indifferent_access
        )
        expect(result).to be true
      end

      it "パスワード設定後はpassword_setがtrueになる" do
        user.update_with_password_check(
          { "password" => "newpassword", "password_confirmation" => "newpassword" }.with_indifferent_access
        )
        expect(user.reload.password_set).to be true
      end
    end

    context "すでにパスワードを設定済みのGoogleアカウントユーザーの場合" do
      let(:user) { create(:user, provider: "google_oauth2", uid: "123456", password_set: true) }

      it "現在のパスワードが必要になる" do
        result = user.update_with_password_check(
          {
            "current_password" => "wrongpassword",
            "password" => "newpassword", "password_confirmation" => "newpassword"
          }.with_indifferent_access
        )
        expect(result).to be false
      end
    end

    context "パスワードを入力しなかった場合" do
      let(:user) { create(:user) }

      it "パスワード以外の項目のみ更新される" do
        result = user.update_with_password_check(
          { "name" => "新しい名前", "password" => "", "password_confirmation" => "" }.with_indifferent_access
        )
        expect(result).to be true
        expect(user.reload.name).to eq("新しい名前")
      end
    end
  end

  describe "振り返りの開始曜日" do
    it "デフォルトは月曜日（1）である" do
      user = create(:user)
      expect(user.review_start_day).to eq(1)
    end
  end

  describe "レベルアップ機能" do
    let(:user) { create(:user) }

    it "経験値0でレベル1かつ称号が正しい" do
      expect(user.level_number).to eq(1)
      expect(user.level_title).to eq("最初の一歩")
    end

    it "経験値10でレベル2かつ称号が正しい" do
      allow(user).to receive(:total_experience).and_return(10)
      expect(user.level_number).to eq(2)
      expect(user.level_title).to eq("歩み始めた")
    end

    it "経験値140でレベル5かつ称号が正しい" do
      allow(user).to receive(:total_experience).and_return(140)
      expect(user.level_number).to eq(5)
      expect(user.level_title).to eq("不屈の歩み")
    end

    it "レベル5では次のレベルがない" do
      allow(user).to receive(:total_experience).and_return(140)
      expect(user.next_level).to be_nil
    end

    it "進捗率が正しく計算される" do
      allow(user).to receive(:total_experience).and_return(19)
      expect(user.level_progress_percentage).to eq(47)
    end
  end
end
