# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class YandexMarketExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/yandex_market"

  # Please use yandex_market/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate

    # Add your extension tab to the admin.
    # Requires that you have defined an admin controller:
    # app/controllers/admin/yourextension_controller
    # and that you mapped your admin in config/routes

    #Admin::BaseController.class_eval do
    #  before_filter :add_yandex_market_tab
    #
    #  def add_yandex_market_tab
    #    # add_extension_admin_tab takes an array containing the same arguments expected
    #    # by the tab helper method:
    #    #    :yandex_market, { :label => "YandexMarketExtension", :route => "/some/non/standard/route" }
    #    add_extension_admin_tab :yandex_market
    #  end
    #end

    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end
  end
end
