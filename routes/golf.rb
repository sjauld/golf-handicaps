class App < Sinatra::Base

  include Rack::Utils

  get '/' do
    haml :index
  end

  # actual playing golf functionality!
  get '/play-golf' do
    @courses = Course.all
    haml :'play-golf/players'
  end

  post '/play-golf' do
    my_course = Course.find(params[:course])
    available_tees = my_course.tees
    # let's make a redis session for fun!
    redis_session_id = SecureRandom.urlsafe_base64
    session['redis_session_id'] = redis_session_id
    $redis.set(redis_session_id,{course: my_course, tees: available_tees, players: params[:players]}.to_json)
    if available_tees.count == 0
      flash[:notice] = 'There are no tees for this course! Please add your tees below.'
      redirect "/course/#{my_course.id}/add-tee"
    elsif available_tees.count == 1
      flash[:notice] = "Only 1 set of tees found. To add more, please click <a href='/course/#{my_course.id}/add-tee'>here</a>"
      redirect '/play-golf/finalise'
    else
      redirect '/play-golf/select-tee'
    end
  end

  # Required if a course has more than one tee!
  get '/play-golf/select-tee' do
    saved_params = JSON.parse($redis.get(session['redis_session_id']))
    @my_course = Course.find(saved_params['course']['id'])
    haml :'play-golf/select-tee'
  end

  # Let's doo it
  get '/play-golf/finalise' do
    saved_params = JSON.parse($redis.get(session['redis_session_id']))
    @my_course = Course.find(saved_params['course']['id'])
    @my_course.inspect
  end




end
