class App < Sinatra::Base

  # user list
  get '/users' do
    @users = User.all
    haml :'user/list'
  end

  # add a user
  get '/users/add' do
    authorize
    haml :'user/add'
  end

  post '/users/add' do
    authorize
    nice_params = escape_html_for_set(params)
    user = User.create({name: nice_params['name'], first_name: nice_params['first_name'], email: nice_params['email'], sex: nice_params['sex']})
    flash[:notice] = 'User created successfully'
    redirect "/users/#{user.id}"
  end

  # refresh handicap
  get '/users/:id/refresh' do
    @this_user = User.find(params[:id])
    authorize_can_edit_user(@this_user)
    @this_user.update_handicap
    flash[:notice] = 'Handicap refreshed'
    redirect "/users/#{params[:id]}"
  end

  # profile edit
  get '/users/:id/edit' do
    @this_user = User.find(params[:id])
    authorize_can_edit_user(@this_user)
    haml :'user/edit_profile'
  end

  post '/users/:id/edit' do
    @this_user = User.find(params[:id])
    authorize_can_edit_user(@this_user)
    nice_params = escape_html_for_set(params)
    ['name','first_name','sex'].each do |x|
      @this_user.send("#{x}=", nice_params[x]) unless nice_params[x].nil?
    end
    @this_user.save
    flash[:notice] = 'User updated'
    redirect "/users/#{params[:id]}"
  end

  # profile page
  get '/users/:id' do
    authorize
    @this_user = User.find(params[:id])
    @rounds = @this_user.rounds.order(played_date: :desc).page(params[:page])
    haml :'user/profile'
  end

end
