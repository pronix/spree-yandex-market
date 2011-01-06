# -*- coding: utf-8 -*-
module Export
  class TorgMailRuExporter
    include ActionController::UrlWriter
    attr_accessor :host, :currencies
    
    SCHEME = Nokogiri::XML('<!DOCTYPE torg_price SYSTEM "shops.dtd" />')
    MCP = 3 # Максимальная цена клика в рублях

    def helper
      @helper ||= ApplicationController.helpers
    end
    
    def export
      # @config = ::TorgMailRu.find_or_create_by_name('Default configuration')
      @config = ::YandexMarket.first
      @host = @config.preferred_url.sub(%r[^http://],'').sub(%r[/$], '')
      ActionController::Base.asset_host = @config.preferred_url
      
      @currencies = @config.preferred_currency.split(';').map{|x| x.split(':')}
      @currencies.first[1] = 1
      
      @categories = Taxon.find_by_name(@config.preferred_category)
      @categories = @categories.self_and_descendants
      @categories_ids = @categories.collect { |x| x.id }
      
      Nokogiri::XML::Builder.new({ :encoding =>"utf-8"}, SCHEME) do |xml|
        xml.torg_price(:date => Time.now.to_s(:ym)) {
          
          xml.shop { # описание магазина
            xml.shopname    @config.preferred_short_name
            xml.company @config.preferred_full_name
            xml.url     path_to_url('')
            
            xml.currencies { # описание используемых валют в магазине
              @currencies && @currencies.each do |curr|
                opt = {:id => curr.first, :rate => curr[1] }
                opt.merge!({ :plus => curr[2]}) if curr[2] && ["CBRF","NBU","NBK","CB"].include?(curr[1])
                xml.currency(opt)
              end
            }        
            
            xml.categories { # категории товара
              @categories_ids && @categories.each do |cat|
                @cat_opt = { :id => cat.id }
                @cat_opt.merge!({ :parentId => cat.parent_id}) unless cat.parent_id.blank?
                xml.category(@cat_opt){ xml  << cat.name }
              end
            }
            xml.offers { # список товаров
              @categories && @categories.each do |cat|
                products = @config.preferred_wares == "on_hand" ? cat.products.active.on_hand : cat.products.active      
                products && products.each do |product|
                  offer(xml,product, cat) if (product and product.master and product.master.price > 0)
                end
              end          
            }
          }
        } 
      end.to_xml
      
    end
    
    
    private
    # :type => "book"
    # :type => "audiobook"
    # :type => misic
    # :type => video
    # :type => tour
    # :type => event_ticket
    
    def path_to_url(path)
      "http://#{@host.sub(%r[^http://],'')}/#{path.sub(%r[^/],'')}"
    end
    
    def offer(xml,product, cat)
      
      product_properties = { }
      product.product_properties.map {|x| product_properties[x.property_name] = x.value }
      offer_simple xml, product, cat
    end
    
    # общая часть для всех видов продукции
    def shared_xml(xml, product, cat)
      xml.url Spree::Config[:yandex_market_use_utm_labels] ? product_url(product, :host => @host, :utm_source => 'torg.mail.ru', :utm_medium => 'cpc', :utm_campaign => 'torg.mail.ru') : product_url(product, :host => @host)
      xml.price product.price
      xml.currencyId @currencies.first.first
      xml.categoryId cat.id
      xml.picture path_to_url(product.images.first.attachment.url(:small, false)) unless product.images.empty?
    end

    
    # простое описание
    def offer_simple(xml, product, cat)
      product_properties = { }
      product.product_properties.map {|x| product_properties[x.property_name] = x.value }
      opt = { :id => product.id,  :available => product.has_stock? }
      xml.offer(opt) {
        shared_xml(xml, product, cat)
        xml.delivery_type       '1'
        xml.delivery_cost       @config.preferred_local_delivery_cost 
        xml.name                product.name
        xml.vendor product_properties[@config.preferred_vendor] if product_properties[@config.preferred_vendor]    
        xml.description         product.description
      }
    end
    
  end

end
