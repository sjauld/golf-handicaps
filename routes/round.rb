require 'csv'

class App < Sinatra::Base

  before '/round/*' do
    authorize
  end

  # add rounds
  # TODO: some authentication over who can add rounds for whom
  get '/round/add' do
    @tee = Tee.find(params[:tee])
    @course = @tee.course
    haml :'/round/add'
  end

  post '/round/add' do
    round = User.find(params[:user]).rounds.create(
      played_date: Date.parse(params['date']),
      playing_handicap: params['played_off'],
      format: params['comp_type'],
      score: params['score'],
      tee_id: params['tee']
    )
    flash[:notice] = 'Round added'
    redirect "/round/add?tee=#{params['tee']}"
  end

  # bulk imports
  get '/round/import' do
    haml :'/round/import'
  end

  post '/round/import' do
    data = params["file"][:tempfile].read
    count = 0
    errors = 0
    CSV.parse(data, headers: true).each do |row|
      begin
        round = User.find(row['User ID']).rounds.create(
          played_date: Date.parse(row['Date']),
          playing_handicap: row['Played off'].to_i,
          format: row['Comp'],
          score: row['Score'],
          tee_id: row['Tee ID']
        )
        round.update_round_statistics
        count += 1
      rescue => e
        puts "#{e.class}: #{e.message}"
        errors += 1
      end
    end
    flash[:notice] = "Added #{count} rounds!" unless count == 0
    flash[:error] = "#{errors} errors occurred!" unless errors == 0
    redirect '/'
  end

  get '/round/:id/delete' do
    round = Round.find(params[:id])
    if round.user.id == @user.id || logged_in_user_is_admin?
      round.delete
      flash[:notice] = 'Success'
    else
      flash[:notice] = 'You are not authorised to delete that round'
    end
    redirect '/'
  end

end
