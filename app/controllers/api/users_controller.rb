class Api::UsersController < ApplicationController
  wrap_parameters include: User.attribute_names + ['password']

  before_action :require_logged_out, only: [:create]

  def create
    @user = User.new(user_params)
    if @user.save
      # debugger
      login!(@user)
      render json: @user
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
    # render json: user_params
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password)
  end

end
