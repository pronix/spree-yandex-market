map.namespace :admin do |admin|
  admin.resource :yandex_markets,
  :collection => {
    :category     => :any,
    :currency     => :any,
    :ware         => :any,
    :export_files => :any,
    :run_export   => :get
  }
end
