@config = YAML.load_file(File.expand_path("./db/config.yml"))[settings.environment.to_s]
ActiveRecord::Base.establish_connection @config

class Archive<ActiveRecord::Base
  has_many :exchange_rates
  has_many :comments, as: :commentable

  # accepts_nested_attributes_for :exchange_rates, reject_if: proc { |att| att['currency'].blank? }, allow_destroy: true

  validates :request_date, presence: true, uniqueness: true
  validates :base_currency, presence: true
  validates_associated :exchange_rates

  # before_save :convert_date
  after_save :request_currencies

  paginates_per 5

  # def convert_date
  #   self.request_date = Date.parse(self.request_date)
  # end

  def request_currencies
    content = Curl.get("https://api.privatbank.ua/p24api/exchange_rates?json&date=#{self.request_date.strftime('%d.%m.%Y')}")
      result = JSON.parse(content.body_str)
        if result["exchangeRate"]
          result["exchangeRate"].each do |rate|
            self.exchange_rates.create(currency: rate["currency"],
                                sale_rate_nb: rate["saleRateNB"],
                                purchase_rate_nb: rate["purchaseRateNB"],
                                sale_rate: rate["saleRate"],
                                purchase_rate: rate["purchaseRate"])
          end
        end

  end

end

class ExchangeRate<ActiveRecord::Base
  belongs_to :archive, dependent: :destroy
  has_many :comments, as: :commentable

  validates :currency, presence: true

  paginates_per 5

  scope :for_archive, ->(id) { where(:archive_id => id) }

end


class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
end