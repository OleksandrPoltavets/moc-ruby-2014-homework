require 'open-uri'
require 'json'

get '/' do
  "MOC lab 9 on Sinatra!"
end

get '/time' do
  time = Time.now
  "Current time is: #{time}"
end

get '/currencies' do
  date = RandTime.random.strftime('%d.%m.%Y')
  content = open("https://api.privatbank.ua/p24api/exchange_rates?json&date=#{date}").read
  result = JSON.parse(content)
  { result: result }.to_json
end

get '/currencies/usd' do
  date = RandTime.random.strftime('%d.%m.%Y')
  content = open("https://api.privatbank.ua/p24api/exchange_rates?json&date=#{date}").read
  result = JSON.parse(content)
  { date: result["date"], bank: result["bank"], base_currency: result["baseCurrencyLit"], usd_sale: result["exchangeRate"][8]["saleRate"], usd_purchase: result["exchangeRate"][8]["purchaseRate"]}.to_json
end
