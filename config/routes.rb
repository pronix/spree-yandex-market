map.yandex_market 'yandex_market', :controller => "yandex_market", :action => :index
map.namespace :admin do |admin|
  admin.resources :yandex_markets
end
