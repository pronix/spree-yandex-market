map.namespace :admin do |admin|
  admin.resource :yandex_markets,
  :collection => {
    :category => :any,
    :currency => :any,
    :ware => :any }
end
