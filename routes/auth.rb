class App < Sinatra::Base

  before '/*' do
    build_user
  end

  # Unauthorized
  get '/401' do
    status 401
    haml :_401
  end

  not_found do
    status 404
    haml :_404
  end

  get '/login' do
    @title = "log in"
    if session['email'].nil?
      haml :login
    else
      flash[:notice] = 'You are already logged in'
      redirect to ('/')
    end
  end

  post '/login' do
    if @user = User.find_by(email: params[:email]).try(:authenticate, params[:password])
      flash[:notice] = 'Log in successful'
      session['email'] = @user.email
      redirect '/'
    else
      flash[:error] = 'Log in failed'
      redirect '/login'
    end
  end

  # login section
  get '/login-with-google' do
    @title = "log in"
    if session['email'].nil?
      redirect to('/auth/google_oauth2')
    else
      redirect to('/')
    end
  end

  get '/auth/google_oauth2/callback' do
    @title = "logged in"
    session.clear
    puts auth_hash.inspect
    auth_hash.info.each_pair do |k,v|
      session[k] = v
    end
    session['id'] = auth_hash['uid']
    puts session.inspect
    # do whatever you want with the information!
    redirect to('/')
  end

  get '/logout' do
    @title = "log out"
    session.clear
    redirect to('/')
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  # self sign-up
  post '/signup' do
    # generate a token and email it
    token = SecureRandom.urlsafe_base64
    address = params['email']
    $redis.set(token,address, {ex: 3600})
    # check if the user exists
    if User.find_by(email: address).nil?
      my_subject = 'IWTA Handicap Signup'
      my_body = "<p>Thanks for signing up. To continue, please click the link:-</p><p><a href='http://iwta.marsupialmusic.net/signup/token/#{token}'>Continue to sign up</a></p>"
    else
      my_subject = 'Password reset'
      my_body = "<p>You forgot your password? Click the link to reset:-</p><p><a href='http://iwta.marsupialmusic.net/password-reset/#{token}'>Password reset</a></p><p>If not, feel free to ignore this email."
    end
    my_body << '<p>--</p><p>Generated by IWTA Handicapping System. If you did not initiate this email, please delete and/or contact sja@marsupialmusic.net</p>'
    message = Mail.new do
      from            ENV['MAIL_FROM']
      to              address
      subject         my_subject
      content_type    'text/html; charset=UTF-8'
      body            my_body
      delivery_method Mail::Postmark, api_token: ENV['POSTMARK_API_TOKEN']
    end
    message.deliver
    flash[:notice] = 'Please check your email for next steps'
    redirect '/'
  end

  # link handling for self sign-up
  get '/signup/token/:token' do
    @email = $redis.get(params['token'])
    if @email.nil?
      flash[:error] = 'It seems your token is invalid or has expired.'
      redirect '/login'
    else
      haml :'user/signup'
    end
  end

  # link handling for password resets
  get '/password-reset/:token' do
    @email = $redis.get(params['token'])
    if @email.nil?
      flash[:error] = 'It seems your token is invalid or has expired.'
      redirect '/login'
    else
      haml :'user/password_reset'
    end
  end

  post '/password-reset/:token' do
    @email = $redis.get(params['token'])
    if @email == params[:email] && ( @user = User.find_by(email: params[:email]) )
      flash[:notice] = 'Password reset successful'
      session['email'] = @user.email
      @user.password = params['password']
      @user.password_confirmation = params['password2']
      @user.save
      redirect '/'
    else
      flash[:error] = 'Some funny business is going on.'
      redirect '/login'
    end
  end

  # form handling for final step sign-up
  post '/signup/complete' do
    puts params.inspect
    @user = User.create(
      name:                   params['name'],
      email:                  params['email'],
      first_name:             params['first_name'],
      last_name:              params['last_name'],
      password:               params['password'],
      password_confirmation:  params['password2']
    )
    session['email'] = @user.email
    redirect '/'
  end

  get '/signup/admin' do
    authorize_admin
    haml :'user/admin'
  end

  post '/signup/admin' do
    authorize_admin
    password = SecureRandom.urlsafe_base64
    this_user = User.create(
      name:                   params['name'],
      email:                  params['email'],
      first_name:             params['first_name'],
      last_name:              params['last_name'],
      password:               password,
      password_confirmation:  password
    )
    flash[:success] = 'User created'
    redirect "/users/#{this_user.id}"
  end

end
