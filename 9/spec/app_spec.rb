require File.expand_path '../spec_helper.rb', __FILE__

DATE = Time.now.strftime('%Y-%m-%d')

describe "'PB Archived currencies App'" do

  it "should generate valid random date" do
    date = RandTime.random
    expect(date.strftime('%d.%m.%Y').length).to eq(10)
    expect(date.strftime('%d.%m.%Y').split('.').length).to eq(3)
  end

  it "should allow accessing the home page" do
    get '/'
    last_response.should be_ok
  end

  it "should have current Date on page '/time'" do
    get '/time'
    expect(last_response.body).not_to be_nil
    expect(last_response.body).to include(DATE)
  end

  it "should return valid full data from PB api '/currencies'" do
    get '/currencies'
    last_response.should be_ok
    expect(JSON.parse(last_response.body)).not_to be_nil
    expect(JSON.parse(last_response.body)["result"]["exchangeRate"].length).to be <= 10
  end

  it "should return valid data from PB api '/currencies/usd'" do
    get '/currencies/usd'
    last_response.should be_ok
    expect(JSON.parse(last_response.body)).not_to be_nil
    expect(JSON.parse(last_response.body)["date"]).to be_kind_of(String)
  end

  it "should return valid currencies for USD '/currencies/usd'" do
    get '/currencies/usd'
    expect(JSON.parse(last_response.body)["usd_sale"]).to be_kind_of(Float)
    expect(JSON.parse(last_response.body)["usd_purchase"]).to be_kind_of(Float)
  end

  it "should return valid base currency '/currencies/usd'" do
    get '/currencies/usd'
    expect(JSON.parse(last_response.body)["base_currency"]).to include("UAH")
  end


end