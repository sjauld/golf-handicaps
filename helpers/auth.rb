module Auth
  def build_user
    if @user.nil? && !session['email'].nil?
      if User.where(email: session['email']).count == 0
        User.create(
          name: session['name'],
          email: session['email'],
          first_name: session['first_name'],
          last_name: session['last_name'],
          sex: session['sex']
        )
      end
      @user = User.where(email: session['email']).first
    end
    @user
  end

  def authorize
    if @user.nil? || @user['email'].nil?
      flash[:notice] = 'You need to login to access that page'
      redirect to('/login')
    end
  end

  def authorized?
    !(@user.nil? || @user['email'].nil?)
  end

  def authorize_admin
    unless logged_in_user_is_admin?
      flash[:error] = 'You are not authorised to do that'
      redirect '/'
    end
  end

  def logged_in_user_is_admin?
    @user.nil? ? false : @user.admin?
  end

  def logged_in_user_is?(user)
    @user.nil? ? false : @user.id == user.id
  end

  def authorize_can_edit_user(user)
    unless logged_in_user_is?(user) || logged_in_user_is_admin?
      flash[:error] = 'You are not authorised to do that'
      redirect '/'
    end
  end

end
