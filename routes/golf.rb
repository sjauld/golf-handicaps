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

  post '/play-golf/select-tee' do
    saved_params = JSON.parse($redis.get(session['redis_session_id']))
    my_tee = Tee.find(params[:tee])
    saved_params[:tees] = [my_tee]
    $redis.set(session['redis_session_id'],saved_params.to_json)
    redirect '/play-golf/finalise'
  end

  # Let's doo it
  get '/play-golf/finalise' do
    @saved_params = JSON.parse($redis.get(session['redis_session_id']))
    raise 'Something went horribly wrong :(' if @saved_params['tees'].count != 1
    @players = User.find(@saved_params['players'])
    haml :'play-golf/finalise'
  end

  post '/play-golf/finalise' do
    @saved_params = JSON.parse($redis.get(session['redis_session_id']))
    batch = Batch.new(sex: 'X')
    params['user'].each do |k,v|
      if batch.sex.upcase != user.sex.upcase
        batch = Batch.find_or_create_by(tee_id: params['tee'], date: Date.parse(params['date']), sex: user.sex.upcase, format: params['format'])
      end
      user = User.find(k)
      round = user.rounds.create(
        played_date: Date.parse(params['date']),
        playing_handicap: v['played_off'],
        format: params['format'],
        score: v['score'],
        tee_id: params['tee'],
        batch_id: batch.id
      )
    end
    flash[:notice] = 'Rounds added successfully!'
    redirect '/'
  end




end
