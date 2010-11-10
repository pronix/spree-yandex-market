# -*- coding: utf-8 -*-
class TorgMailRu < Configuration

  preference :category,        :string
  preference :currency,        :string, :default => 'RUR'
  preference :wares,           :string, :default => "active"
  preference :number_of_files, :integer, :default => 5
  preference :short_name,      :string, :default => 'BestShop'
  preference :full_name,       :string, :default => 'BestShop Ltd'
  preference :url,             :string, :default => 'http://localhost:3000/'
  preference :local_delivery_cost, :float # стоимость доставки по своему региону


  # wares property 
  preference :vendor,          :string, :default => "vendor"        # Производитель

end
