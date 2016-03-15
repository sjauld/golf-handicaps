class App < Sinatra::Base

  # add rounds
  # TODO: some authentication over who can add rounds for whom
  get '/round/add' do
    @tee = Tee.find(params[:tee])
    @course = @tee.course
    haml :'/round/add'
  end

  post '/round/add' do
    User.find(params[:user]).rounds.create(
      played_date: Date.parse(params['date']),
      playing_handicap: params['played_off'],
      format: params['comp_type'],
      score: params['score'],
      tee_id: params['tee']
    )
    flash[:notice] = 'Round added'
    redirect "/round/add?tee=#{params['tee']}"
  end
end
