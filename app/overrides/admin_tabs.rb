Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "converted_admin_tabs",
                     :insert_after => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%=  tab(:yandex_market, { :route => \"admin_yandex_market_settings\" })  %>",
                     :disabled => false)
