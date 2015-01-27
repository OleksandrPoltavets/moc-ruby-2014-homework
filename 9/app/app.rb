require 'open-uri'
require 'json'

get '/' do
  "MOC lab 9 on Sinatra!"
end

get '/time' do
  "Current time is: #{Time.now}"

  #https://api.privatbank.ua/p24api/exchange_rates?json&date=01.12.2013
end

get '/pb' do
  date = RandTime.random.strftime('%d.%m.%Y')

  content = open("https://api.privatbank.ua/p24api/exchange_rates?json&date=#{date}").read
  result = JSON.parse(content)

  # {currencies: result}.to_json
  { date: result["date"], bank: result["bank"], base_currency: result["baseCurrencyLit"], usd_sale: result["exchangeRate"][8]["saleRate"], usd_purchase: result["exchangeRate"][8]["purchaseRate"]}.to_json
end
