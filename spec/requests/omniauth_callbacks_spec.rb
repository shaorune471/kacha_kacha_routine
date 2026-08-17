require "rails_helper"

RSpec.describe "Googleログイン", type: :request do
  def google_auth(uid: "123456", email: "google@example.com", name: "Googleユーザー")
    OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: uid,
      info: OmniAuth::AuthHash::InfoHash.new(email: email, name: name)
    )
  end

  def stub_auth(auth)
    OmniAuth.config.mock_auth[:google_oauth2] = auth
  end

  describe "GET /users/auth/google_oauth2/callback" do
    context "初めてGoogleでログインするユーザーの場合" do
      it "ユーザーが新規作成される" do
        stub_auth(google_auth)

        expect {
          get user_google_oauth2_omniauth_callback_path
        }.to change(User, :count).by(1)

        user = User.find_by(provider: "google_oauth2", uid: "123456")
        expect(user).to be_present
        expect(user.email).to eq("google@example.com")
        expect(user.name).to eq("Googleユーザー")
      end

      it "サインインした状態になる" do
        stub_auth(google_auth)
        get user_google_oauth2_omniauth_callback_path
        user = User.find_by(provider: "google_oauth2", uid: "123456")
        expect(controller.current_user).to eq(user)
      end

      it "オンボーディング用のセッションが設定される" do
        stub_auth(google_auth)
        get user_google_oauth2_omniauth_callback_path
        expect(session[:onboarding]).to be true
      end

      it "アプリの使い方ページにリダイレクトされる" do
        stub_auth(google_auth)
        get user_google_oauth2_omniauth_callback_path
        expect(response).to redirect_to(guide_path)
      end
    end

    context "すでにGoogleアカウントが連携済みのユーザーの場合" do
      let!(:existing_user) { create(:user, provider: "google_oauth2", uid: "123456") }

      it "ユーザーが新規作成されない" do
        stub_auth(google_auth(uid: "123456", email: existing_user.email, name: existing_user.name))

        expect {
          get user_google_oauth2_omniauth_callback_path
        }.not_to change(User, :count)
      end

      it "オンボーディング用のセッションが設定されない" do
        stub_auth(google_auth(uid: "123456"))
        get user_google_oauth2_omniauth_callback_path
        expect(session[:onboarding]).to be_nil
      end

      it "ホーム画面にリダイレクトされる" do
        stub_auth(google_auth(uid: "123456"))
        get user_google_oauth2_omniauth_callback_path
        expect(response).to redirect_to(home_path)
      end
    end

    context "取得した情報でユーザーの保存に失敗する場合" do
      it "ユーザーが作成されない" do
        stub_auth(google_auth(name: ""))

        expect {
          get user_google_oauth2_omniauth_callback_path
        }.not_to change(User, :count)
      end

      it "新規登録ページにリダイレクトされる" do
        stub_auth(google_auth(name: ""))
        get user_google_oauth2_omniauth_callback_path
        expect(response).to redirect_to(new_user_registration_url)
      end

      it "バリデーションエラーの内容がアラートに含まれる" do
        stub_auth(google_auth(name: ""))
        get user_google_oauth2_omniauth_callback_path
        expect(flash[:alert]).to include("名前")
      end
    end

    context "OmniAuth側で認証に失敗した場合" do
      it "トップページにリダイレクトされる" do
        stub_auth(:invalid_credentials)
        get user_google_oauth2_omniauth_callback_path
        expect(response).to redirect_to(root_path)
      end

      it "エラーメッセージが表示される" do
        stub_auth(:invalid_credentials)
        get user_google_oauth2_omniauth_callback_path
        expect(flash[:alert]).to eq("Google認証に失敗しました。")
      end

      it "ユーザーが作成されない" do
        stub_auth(:invalid_credentials)
        expect {
          get user_google_oauth2_omniauth_callback_path
        }.not_to change(User, :count)
      end
    end
  end
end
