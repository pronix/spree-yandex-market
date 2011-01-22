require 'spree_core'
require 'yandex_market_hooks'

module YandexMarket
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    end

    rake_tasks do
      puts File.join(File.dirname(__FILE__), "tasks/yandex_market.rake").inspect
      load File.join(File.dirname(__FILE__), "tasks/yandex_market.rake")
    end

    config.to_prepare &method(:activate).to_proc
  end

  class Config
    include Singleton
    include Spree::PreferenceAccess

    class << self
      def instance
        return @configuration if @configuration
        return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
        @configuration ||= YandexMarketConfiguration.find_or_create_by_name("Default configuration")
        @configuration
      end
    end
  end
  
end
