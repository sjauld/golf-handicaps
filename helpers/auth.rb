module Auth
  def build_user
    if @user.nil? && !session['email'].nil?
      if User.where(email: session['email']).count == 0
        User.create(
          name: session['name'],
          email: session['email'],
          first_name: session['first_name'],
          last_name: session['last_name'],
          image: session['image']
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

  # TODO: create admin users instead of just using user #1
  def authorize_admin
    unless @user.id == 1
      flash[:error] = 'You are not authorised to do that'
      redirect '/'
    end
  end

end
