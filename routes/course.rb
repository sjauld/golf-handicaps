class App < Sinatra::Base

  # Add courses!
  get '/course/add' do
    authorize
    haml :'course/add'
  end

  post '/course/add' do
    authorize
    nice_params = escape_html_for_set(params)
    course = Course.create({name: params['name'], website: params['website'], image: params['image']})
    flash[:notice] = 'Course created successfully!'
    redirect "/course/#{course.id}"
  end

  # Get course list!
  get '/course/list' do
    @courses = Course.order(name: :asc).limit(50).offset(params[:page].to_i * 50)
    haml :'course/list'
  end

  # Get course detail
  get '/course/:id' do
    @course = Course.find(params[:id])
    @tees = @course.tees
    haml :'course/detail'
  end

  # Add some tees
  get '/course/:id/add-tee' do
    authorize
    @course = Course.find(params[:id])
    haml :'course/add_tee'
  end

  post '/course/:id/add-tee' do
    authorize
    @course = Course.find(params[:id])
    @course.tees.new({colour: params[:colour], acr: params[:acr], slope: params[:slope], par: params[:par]}).save
    flash[:notice] = 'Tee created successfully!'
    redirect "/course/#{params[:id]}"
  end

end
