class UsersController < ApplicationController

  def show
    @user = User.find_by(nickname: params[:nickname])
     # authorize @user
    skip_authorization

    @audio = Audio.find(params[:audio]) if params[:audio]
    @url = @audio.audio_url if params[:audio]

    # @fav_playlist = @user.playlits.first

    # @favorites_audio = Audio.find(params[:favorites_audio]) if params[:favorites_audio]

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @user = User.find_by(nickname: params[:nickname])
     # @user = authorize User.new
  end

  def update
    @user = authorize User.find_by(nickname: params[:nickname])
    @user.update!(user_params)

    redirect_to user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :nickname, :user_bio)
  end
end
