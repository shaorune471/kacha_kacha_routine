class ReframingsController < ApplicationController
  def index
    @message = REFRAMING_MESSAGE
  end

  def finish_onboarding
    session.delete(:onboarding)
    redirect_to home_path
  end
end
