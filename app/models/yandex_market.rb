# class YandexMarket < ActiveRecord::Base
class YandexMarket < Configuration
  preference :category,     :string
  preference :currency,     :string
  preference :only_on_hand, :boolean, :default => false
  preference :all_active,   :boolean, :default => true
  
end
