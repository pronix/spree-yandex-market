Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "converted_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%=  tab(:yandex_market, :icon => 'icon-shopping-cart', :route => 'admin_yandex_market_settings' )  %>",
                     :disabled => false)
