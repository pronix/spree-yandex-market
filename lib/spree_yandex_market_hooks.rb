class SpreeYandexMarketHooks < Spree::ThemeSupport::HookListener
  insert_after :admin_tabs do
    %(<%=  tab(:yandex_market, { :route => "admin_yandex_market_settings" })  %>)
  end
end
