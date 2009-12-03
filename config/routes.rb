map.namespace :admin do |admin|
  admin.resource :yandex_markets,
  :collection => {
    :general      => :any,    
    :currency      => :any,
    :export_files  => :any,
    :ware_property => :any,
    :run_export    => :get
  }
end
