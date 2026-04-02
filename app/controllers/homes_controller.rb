class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @habits = current_user.habits
  end
end
