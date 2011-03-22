require 'spree_core'
require 'spree_yandex_market_hooks'

module SpreeYandexMarket
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    end

#    rake_tasks do
#      load File.join(File.dirname(__FILE__), "tasks/yandex_market.rake")
#    end

    config.to_prepare &method(:activate).to_proc
  end
  
end
