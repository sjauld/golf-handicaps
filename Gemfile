ruby '2.3.0'
source 'https://rubygems.org' do

  group :core do
    gem 'omniauth-google-oauth2'
    gem 'sinatra'
    gem 'haml'
    gem 'activerecord'
    gem 'sinatra-activerecord'
    gem 'sinatra-flash'
    gem 'sinatra-redirect-with-flash'
    gem 'sinatra-asset-pipeline'
    gem 'uglifier'
    gem 'dotenv'
    gem 'redis'

    # pagination
    gem 'kaminari', :require => 'kaminari/sinatra'
    # gem 'padrino-helpers' TODO: work out how to work this without breaking everything

    # email functionality
    gem 'postmark'
    gem 'mail'

    # User extensions
    gem 'bcrypt', '~> 3.1.7'
    gem 'gravtastic'
  end

  group :development do
    gem 'sqlite3'
    gem 'tux'
    gem 'rerun'
  end

  group :production do
    gem 'pg'
  end

end

source 'https://rails-assets.org' do
  group :assets do
    gem 'rails-assets-bootstrap'
    gem 'rails-assets-bootstrap3-datetimepicker'
    gem 'rails-assets-jquery'
    gem 'rails-assets-moment'
    gem 'rails-assets-jquery.validation'
    gem 'rails-assets-multiselect'
  end
end
