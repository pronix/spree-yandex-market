require 'spree_core'

module Spree::YandexMarket
end

module SpreeYandexMarket
  class Engine < Rails::Engine
    railtie_name "spree_yandex_market"

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree.yandex_market.preferences", :after => "spree.environment" do |app|
      Spree::YandexMarket::Config = Spree::YandexMarketConfiguration.new
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    #    rake_tasks do
    #      load File.join(File.dirname(__FILE__), "tasks/yandex_market.rake")
    #    end

    config.to_prepare &method(:activate).to_proc
  end

end
