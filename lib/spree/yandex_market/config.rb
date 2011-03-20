module Spree
  module YandexMarket
    # Singleton class to access the advanced cart configuration object (YandexMarketConfiguration.first by default) and it's preferences.
    #
    # Usage:
    #   Spree::YandexMarket::Config[:foo]                  # Returns the foo preference
    #   Spree::YandexMarket::Config[]                      # Returns a Hash with all the google base preferences
    #   Spree::YandexMarket::Config.instance               # Returns the configuration object (YandexMarketConfiguration.first)
    #   Spree::YandexMarket::Config.set(preferences_hash)  # Set the advanced cart preferences as especified in +preference_hash+
    class Config
      include Singleton
      include PreferenceAccess

      class << self
        def instance
          return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
          YandexMarketConfiguration.find_or_create_by_name("Yandex Market configuration")
        end
      end
    end
  end
end

