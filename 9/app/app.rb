require 'open-uri'

get '/' do
  "MOC lab 9 on Sinatra!"
end

get '/time' do
  "Current time is: #{Time.now}"

  #https://api.privatbank.ua/p24api/exchange_rates?json&date=01.12.2013
end

get '/pb' do
  # response = Net::HTTP.get_response("api.privatbank.ua","/p24api/exchange_rates?json&date=01.12.2013")
  # puts response.body #this must show the JSON contents

  content = open("https://api.privatbank.ua/p24api/exchange_rates?json&date=01.12.2013").read
  {currencies: content}.to_json
end
