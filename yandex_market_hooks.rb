class YandexMarketHooks < Spree::ThemeSupport::HookListener

  insert_after :admin_tabs do
    %(<%=  tab(:yandex_market, { :route => "admin_yandex_markets" })  %>)
  end

  insert_after :admin_product_form_right do
    %(
    <p>
    <%= f.label :export_to_yandex_market, t("export_to_yandex_market") %><br />
    <%= f.check_box :export_to_yandex_market %></p>
   )
  end

  # def add_yandex_market_tab
  #   #    # add_extension_admin_tab takes an array containing the same arguments expected
  #   #    # by the tab helper method:
  #   #    #    :yandex_market, { :label => "YandexMarketExtension", :route => "/some/non/standard/route" }
  #   # "/admin/yandex_markets" admin_yandex_markets_path
  #   add_extension_admin_tab :yandex_market, { :label => "yandex_market", :route => "admin_yandex_markets" }
  # end

end
