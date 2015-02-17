require 'bundler/setup'
Bundler.require(:default)

require 'rubygems'
require 'sinatra/base'
require 'sinatra/contrib/all'
require 'sinatra/reloader'
require 'padrino-helpers'
require 'kaminari'
require 'json'
require 'curb'

::Kaminari::Hooks.init
register Kaminari::Helpers::SinatraHelpers
register Padrino::Helpers

enable :sessions
enable :logging
enable :protect_from_csrf

case settings.environment
  when development?
    require 'sinatra/reloader'
    require 'better_errors'
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
end

set :sessions, key: 'N&wedhSDF',
    domain: "localhost",
    path: '/',
    expire_after: 14400,
    secret: '*&(^B234'


require "./models"

get "/" do
  redirect to("/archives")
end

get "/archives" do
  page = 1
  page = params[:page] if params[:page]

  archives = Archive.all.page(page)
  erb :index, locals: {archives: archives, page: page}, layout: "layout"
end

get "/archives/new" do
  archive = Archive.new
  erb :new, locals: {archive: archive}, layout: "layout"
end

get "/archives/:id/edit" do |id|
  archive = Archive.find(id)
  erb :edit, locals: {archive: archive}, layout: "layout"
end


post "/archives" do
  archive = Archive.new(params[:archive])
  if archive.save
    redirect to("/archives/#{archive.id}")
  else
    erb :new, locals: {archive: archive}, layout: "layout"
  end
end

put "/archives/:id" do |id|
  archive = Archive.find(id)
  archive.update_attributes(params[:archives])
  if archive.save
    redirect to("/archives/#{archive.id}")
  else
    erb :edit, locals: {archive: archive}, layout: "layout"
  end


end

delete "/archives/:id" do |id|
  archive = Archive.find(id)
  archive.destroy
  redirect to("/archives")
end

get "/archives/:id" do |id|
  archive = Archive.find(id.to_i)
  erb :show, locals: {archive: archive}, layout: "layout"
end

get "/archives/:id/exchange_rates" do |id|
  page = 1
  page = params[:page] if params[:page]

  date = Archive.select("request_date").find(id.to_i).request_date.strftime('%d.%m.%Y')
  exchange_rates = ExchangeRate.for_archive(id).page(page)

  erb :rates, locals: {date: date, exchange_rates: exchange_rates}, layout: "layout"
end