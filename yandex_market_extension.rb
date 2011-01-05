# encoding: utf-8
# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class YandexMarketExtension < Spree::Extension
  version "1.0"
  description "Export products to Yandex.Market"
  url "http://yourwebsite.com/yandex_market"

  # Please use yandex_market/config/routes.rb instead for extension routes.

  def self.require_gems(config)
    config.gem "nokogiri", :version => '>=1.4.0'
  end

  def activate

    AppConfiguration.class_eval do
      preference :yandex_market_use_utm_labels, :boolean, :default => false
    end

    # Add your extension tab to the admin.
    # Requires that you have defined an admin controller:
    # app/controllers/admin/yourextension_controller
    # and that you mapped your admin in config/routes

    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end
  end
end
