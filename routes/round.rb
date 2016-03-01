class App < Sinatra::Base

  # add rounds
  get '/round/add' do
    @tee = Tee.find(params[:tee])
    @course = @tee.course
    haml :'/round/add'
  end
end
