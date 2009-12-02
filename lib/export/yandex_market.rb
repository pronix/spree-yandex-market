module Export
  class YandexMarket
    include ActionController::UrlWriter
    attr_accessor :host, :wares_type, :currencies
    
    SCHEME = Nokogiri::XML('<!DOCTYPE yml_catalog SYSTEM "shops.dtd" />')
    WARES_TYPE = "wares_type"
    DEFAULT_OFFEN = "vendor_model"
    def initialize
      @host = Spree::Config[:site_url] 
      ActionController::Base.asset_host = Spree::Config[:site_url] 
      @wares_type = Property.find_by_name(WARES_TYPE)
    end
  
    def helper
      @helper ||= ApplicationController.helpers
    end
  
    def export
      @config = ::YandexMarket.first
      @currencies = @config.preferred_currency.split(';').map{|x| x.split(':')}
      @currencies.first[1] = 1
      
      @categories = Taxon.find_by_name(@config.preferred_category)
      @categories = @categories.self_and_descendants
      @categories_ids = @categories.collect { |x| x.id }
            
      Nokogiri::XML::Builder.new({ :encoding =>"windows-1251"}, SCHEME) do |xml|
        xml.yml_catalog(:date => Time.now.to_s(:ym)) {
          
          xml.shop { # описание магазина
            xml.name    Spree::Config[:site_name]
            xml.company Spree::Config[:site_name]
            xml.url     path_to_url(Spree::Config[:site_url])
          }
          
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
                offer(xml,product, cat)
              end
            end          
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
      wares_type_value = product.product_properties.find_by_property_id(@wares_type) &&
        product.product_properties.find_by_property_id(@wares_type).value
      if ["book", "audiobook", "music", "video", "tour", "event_ticket", "simple", "vendor_model"].include? wares_type_value
        send("offer_#{wares_type_value}".to_sym, xml, product, cat)
      else
        send("offer_#{DEFAULT_OFFEN}".to_sym, xml, product, cat)      
      end
    end
    
    # общая часть для всех видов продукции
    def shared_xml(xml, product, cat)
      xml.url product_url(product, :host => @host)
      xml.price product.price
      xml.currencyId @currencies.first.first
      xml.categoryId cat.id
      xml.picture path_to_url(product.images.first.attachment.url(:small, false)) unless product.images.empty?
    end

    
  # # Описание элементов, входящих в элемент <offer>
    # # элементы   Описание
    
    # # typePrefix  Группа товаров \ категория
    # # vendor  Производитель
# # model  Модель
    # # name Наименование товарного предложения
    
    # # delivery  Элемент, обозначающий возможность доставить соответствующий товар. "false" данный товар не может быть доставлен("самовывоз"). "true" товар доставляется на условиях, которые указываются в партнерском интерфейсе http://partner.market.yandex.ru на странице "редактирование".
    
    # # description  Описание товарного предложения
    
# # vendorCode  Код товара (указывается код производителя)
    # # local_delivery_cost  Стоимость доставки данного товара в Своем регионе
    # # available  Статус доступности товара - в наличии/на заказ
    # # available="false" - товарное предложение на заказ. Магазин готов осуществить поставку товара на указанных условиях в течение месяца (срок может быть больше для товаров, которые всеми участниками рынка поставляются только на заказ).. Те товарные предложения, на которые заказы не принимаются, не должны выгружаться в Яндекс.Маркет.
    # # available="true" - товарное предложение в наличии. Магазин готов сразу договариваться с покупателем о доставке товара
    # # sales_notes  Элемент, предназначенный для того, чтобы показать пользователям, чем отличается данный товар от других, или для описания акций магазина (кроме скидок). Допустимая длина текста в элементе - 50 символов.
    # # manufacturer_warranty  Элемент предназначен для отметки товаров, имеющих официальную гарантию производителя.
    # # country_of_origin  Элемент предназначен для указания страны производства товара.
    
    # # downloadable  Элемент предназначен обозначения товара, который можно скачать.
    
  # Обычное описание
    def offer_vendor_model(xml,product, cat)
      opt = { :id => product.id, :type => "vendor.model", :available => product.has_stock? }
      xml.offer(opt) {
        shared_xml(xml, product, cat)
        
        xml.delivery ""
        xml.local_delivery_cost ""
        
        xml.typePrefix ""
        xml.vendor ""
        xml.vendorCode ""
        xml.model ""
        
        xml.description product.description
        xml.manufacturer_warranty ""
      
        xml.country_of_origin ""
        xml.downloadable false
      }
    end

    # простое описание
    def offer_simple(xml, product, cat)
      opt = { :id => product.id,  :available => product.has_stock? }
      xml.offer(opt) {
        shared_xml(xml, product, cat)
        
        xml.delivery ""
        xml.local_delivery_cost ""
        xml.name ""
        xml.vendorCode ""
        xml.description product.description
        
        xml.country_of_origin ""
        xml.downloadable false
      }
  end
    
    # Книги
    def offer_book(xml, product, cat)
      opt = { :id => product.id, :type => "book", :available => product.has_stock? }
      xml.offer(opt) {
        shared_xml(xml, product, cat)
        
        xml.delivery ""
        
        xml.author ""
        xml.name ""
        xml.publisher ""
        xml.series ""
        xml.year ""
        xml.ISBN ""
        xml.volume ""
        xml.part ""
        xml.language ""
      
        xml.binding ""
        xml.page_extent ""
        
        xml.description product.description
        xml.downloadable false
      }
  end
    
    # Аудиокниги
    def offer_audiobook(xml, product, cat)
      opt = { :id => product.id, :type => "audiobook", :available => product.has_stock?  }
      xml.offer(opt) {  
        shared_xml(xml, product, cat)
        
        xml.author ""
        xml.name ""
        xml.publisher ""
        xml.series ""
        xml.year ""
        xml.ISBN ""
        xml.volume ""
        xml.part ""
        xml.language ""
      
        xml.performed_by ""
        xml.storage ""
        xml.format ""
        xml.recording_length ""
        xml.description product.description
        xml.downloadable true
      
      }
    end
    
  # Описание музыкальной продукции
    def offer_music(xml, product, cat)
    opt = { :id => product.id, :type => "artist.title", :available => product.has_stock?  }
      xml.offer(opt) {
        shared_xml(xml, product, cat)
        
        xml.delivery ""
      
        xml.artist ""
        xml.title ""
        xml.year ""
        xml.media ""
        xml.volume ""
        
        xml.description product.description
        
    }
    end
    
    # Описание видео продукции:
    def offer_video(xml, product, cat)
      opt = { :id => product.id, :type => "artist.title", :available => product.has_stock?  }
      xml.offer(opt) {
        shared_xml(xml, product, cat)
        
        xml.delivery ""
      
        xml.title ""
        xml.year ""
        xml.media ""
        xml.starring ""
        xml.director ""
        xml.originalName ""
        xml.country_of_origin
        xml.description product_url.description
      }
  end
    
  # Описание тура
    def offer_tour(xml, product, cat)
      opt = { :id => product.id, :type => "tour", :available => product.has_stock?  }
      xml.offer(opt) {
        shared_xml(xml, product, cat)
        
        xml.delivery ""
        
        xml.local_delivery_cost ""
        xml.worldRegion ""
        xml.country ""
        xml.region ""
        xml.days ""
        xml.dataTour ""
        xml.dataTour ""
        xml.name ""
        xml.hotel_stars ""
        xml.room ""
        xml.meal ""
        xml.included ""
        xml.transport ""
        xml.description product.description
      }
    end
    
    # Описание билетов на мероприятия
    def offer_event_ticket(xml, product, cat)
      opt = { :id => product.id, :type => "event-ticket", :available => product.has_stock?  }    
      xml.offer(opt) {
        shared_xml(xml, product, cat)
        
        xml.delivery ""
        xml.local_delivery_cost ""
        
        xml.name ""
        xml.place ""
        xml.hall(:plan => "url_plan") { xml << "" }
        xml.hall_part ""
        xml.date ""
        xml.is_premiere ""
        xml.is_kids ""
        xml.description product.description
      }
    end
    
  end
  
end
