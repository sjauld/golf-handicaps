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
    user = User.create({name: nice_params['name'], first_name: nice_params['first_name'], email: nice_params['email'], image: nice_params['image']})
    flash[:notice] = 'User created successfully'
    redirect "/users/#{user.id}"
  end

  # refresh handicap
  get '/users/:id/refresh' do
    authorize
    @this_user = User.find(params[:id])
    @this_user.update_handicap
    flash[:notice] = 'Handicap refreshed'
    redirect "/users/#{params[:id]}"
  end

  # profile page
  get '/users/:id' do
    authorize
    @this_user = User.find(params[:id])
    @page = (params[:p] || 1).to_i
    @rounds = @this_user.rounds.order(played_date: :desc).limit(20).offset((@page - 1) * 20)
    haml :'user/profile'
  end

end
