# class YandexMarket < ActiveRecord::Base
class YandexMarket < Configuration
  preference :category,        :string
  preference :currency,        :string
  preference :wares,           :string,  :default => "active"
  preference :number_of_files, :integer, :default => 5

end
