class UsersController < ApplicationController

  def show
    @user = User.find_by(nickname: params[:nickname]) || User.find(params[:nickname])
     # authorize @user
    skip_authorization

    @audios = @user.audios.paginate(page: params[:page], per_page: 5)

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
    @user = authorize User.find_by(nickname: params[:nickname])
     # @user = authorize User.new
  end

  def update
    @user = User.find_by(nickname: params[:nickname])
    @user.update!(user_params)
    skip_authorization

    redirect_to user_path(@user)
  end

  def follow
    # @follow = Follow.find_by(follower: @current_user, followable: @user)
    @user = User.find_by(nickname: params[:nickname])
    current_user.follow(@user)
    @activity = @user.create_activity :follow, owner: current_user

    # if @user != current_user
      ActionCable.server.broadcast("activities-#{@user.id}", {
        activity_partial: render_to_string(partial: "shared/activity", locals: { activity: @activity, user_id: @user.id })
      })
    # end

    skip_authorization

    respond_to :js
  end

  def unfollow
    @user = User.find_by(nickname: params[:nickname])
    current_user.stop_following(@user)
    skip_authorization

    respond_to :js
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :nickname, :user_bio, :avatar)
  end
end
