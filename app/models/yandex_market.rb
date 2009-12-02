# class YandexMarket < ActiveRecord::Base
class YandexMarket < Configuration
  preference :category,     :string
  preference :currency,     :string
  preference :wares,        :string, :default => "active"
  
end
