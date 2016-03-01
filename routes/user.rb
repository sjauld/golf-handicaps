class App < Sinatra::Base

  # user list
  get '/user/' do
    @users = User.all
    haml :'user/list'
  end

  # add a user
  get '/user/add' do
    haml :'user/add'
  end

  post '/user/add' do
    nice_params = escape_html_for_set(params)
    user = User.create({name: nice_params['name'], first_name: nice_params['first_name'], email: nice_params['email'], image: nice_params['image']})
    flash[:notice] = 'User created successfully'
    redirect "/user/profile/#{user.id}"
  end

  # profile page
  get '/user/profile/:id' do
    @this_user = User.find(params[:id])
    haml :'user/profile'
  end

end
