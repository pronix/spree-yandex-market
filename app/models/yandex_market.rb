# class YandexMarket < ActiveRecord::Base
class YandexMarket < Configuration
  preference :category,        :string
  preference :currency,        :string
  preference :wares,           :string,  :default => "active"
  preference :number_of_files, :integer, :default => 5
  preference :short_name,      :string
  preference :full_name,       :string
  preference :url,             :string
  preference :local_delivery_cost, :float # стоимость доставки по своему региону

  
  # wares property 
  preference :type_prefix,     :string, :default => "prefix"   # Группа товаров \ категория
  preference :vendor,          :string, :default => "vendor"        # Производитель
  preference :model,           :string, :default => "model"         # Модель
  preference :vendor_code,     :string,  :default => "vendor_code"  # Код товара (указывается код производителя)
  preference :country_of_manufacturer, :string, :default => "country_of_manufacturer" #страны производства товара.
  preference :manufacturer_warranty, :string, :default => "manufacturer_warranty" # есть официальная гарантию производителя.
  preference :wares_type,      :string, :default => "wares_type"   # Тип Товара
  
end
