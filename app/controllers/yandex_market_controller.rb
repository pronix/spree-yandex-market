class YandexMarketController < ApplicationController
  def index 
    render :layout => false, :xml => _build_xml
  end
  
  private

  def _build_xml
    
    @curr = Struct.new(:id, :rate)
    @current_currency = @curr.new("RUR", 1)
    @currencies = [["USD","23.98"],["EUR","36.25"],
                  ["UAH","5.6"],["KZT","0.19"]].collect{ |x| @curr.new(x.first, x.last) }
    
    @cat = Struct.new(:id, :parent_id, :name)
    @categories = (1..10).collect{ |x| @cat.new( x,x+1,"name_#{x}")}
    
    @products = [] # список товаров
    
    scheme = Nokogiri::XML('<!DOCTYPE yml_catalog SYSTEM "shops.dtd" />')
    Nokogiri::XML::Builder.new({ :encoding =>"windows-1251"}, scheme) do |xml|
      xml.yml_catalog(:date => Time.now.strftime("%Y-%m-%d %H:%m")) {
        xml.shop { # описание магазина
          xml.name    Spree::Config[:site_name]
          xml.company Spree::Config[:site_name]
          xml.url     Spree::Config[:site_url]
          
          xml.currencies { # описание используемых валют в магазине
            xml.currency(:id => @current_currency.id, :rate => 1) # основаная валюта магазина
            @currencies && @currencies.each do |curr|
              xml.currency(:id => curr.id, :rate => curr.rate)
            end
          }
          
          xml.categories { # категории товара
            @categories && @categories.each do |cat|
              @cat_opt = { :id => cat.id }
              @cat_opt.merge!({ :parentId => cat.parent_id}) unless cat.parent_id.blank?
              xml.category(@cat_opt){ xml  << cat.name }
            end
          }
          
          xml.offers { # список товаров
            @products.each do |product|
              offer_vendor_model(xml,product)
            end
          }
          
        }
      }
    end.to_xml
  end
  
  
  def offer_vendor_model(xml,product)
    xml.offer(:id => product.id, :type => "vendor.model") {
      xml.url ""
      xml.price ""
      xml.currencyId ""
      xml.categoryId ""
      xml.picture ""
      xml.delivery ""
      xml.local_delivery_cost ""
      xml.typePrefix ""
      xml.vendor ""
      xml.model ""
      xml.description ""
      xml.manufacturer_warranty ""
      xml.country_of_origin ""
    }
  end
  
  def offer_simple(xml,product)
    xml.offer(:id => product.id, :available => "true") {
      xml.url ""
      xml.price ""
      xml.currencyId ""
      xml.categoryId ""
      xml.picture ""
      xml.delivery ""
      xml.local_delivery_cost ""
      xml.name ""
      xml.vendorCode ""
      xml.description ""
      xml.country_of_origin ""
    }
  end

  def offer_book(xml, product)
    xml.offer(:id => product.id, :type => "book", :available => "true") {
      xml.url ""
      xml.price ""
      xml.currencyId ""
      xml.categoryId ""
      xml.picture ""
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
      xml.description ""
      xml.downloadable false
    }
  end
  
  def offer_audiobook(xml, product)
    xml.offer(:id => product.id, :type => "audiobook", :available => "true") {
      xml.url ""
      xml.price ""
      xml.currencyId ""
      xml.categoryId ""
      xml.picture ""

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
      xml.description ""
      xml.downloadable true
      
    }
  end
  
  def offer_music(xml, product)
    xml.offer(:id => product.id, :type => "artist.title", :available => "true") {
      xml.url ""
      xml.price ""
      xml.currencyId ""
      xml.categoryId ""
      xml.picture ""
      xml.delivery ""
      xml.artist ""
      xml.title ""
      xml.year ""
      xml.media ""
      xml.volume ""
      xml.description ""
      xml.downloadable false
    }
  end
  
  def offer_video(xml, product)
    xml.offer(:id => product.id, :type => "artist.title", :available => "true") {
      xml.url ""
      xml.price ""
      xml.currencyId ""
      xml.categoryId ""
      xml.picture ""
      xml.delivery ""
      xml.title ""
      xml.year ""
      xml.media ""
      xml.starring ""
      xml.director ""
      xml.originalName ""
      xml.country
      xml.description ""
    }
  end

  def offer_tour(xml, product)
     xml.offer(:id => product.id, :type => "tour", :available => "true") {
      xml.url ""
      xml.price ""
      xml.currencyId ""
      xml.categoryId ""
      xml.picture ""
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
      xml.description ""
    }
  end
  
  def offer_event_ticket(xml, product)
     xml.offer(:id => product.id, :type => "event-ticket", :available => "true") {
      xml.url ""
      xml.price ""
      xml.currencyId ""
      xml.categoryId ""
      xml.picture ""
      xml.delivery ""
      xml.local_delivery_cost ""
      
      xml.name ""
      xml.place ""
      xml.hall(:plan => "url_plan") { xml << "" }
      xml.hall_part ""
      xml.date ""
      xml.is_premiere ""
      xml.is_kids ""
      xml.description ""
    }
  end
end

# Описание элементов, входящих в элемент <offer>
# элементы   Описание

# url   URL-адрес страницы товара
# price  Цена, по которой данный товар можно приобрести.Цена товарного предложения округляеся и выводится в зависимости от настроек пользователя.
# currencyId  Идентификатор валюты товара (RUR, USD, UAH, KZT). Для корректного отображения цены в национальной валюте, необходимо использовать идентификатор (например, UAH) с соответствующим значением цены.
# categoryId  Идентификатор категории товара (целое число не более 18 знаков). Товарное предложение может принадлежать только одной категории
# picture  Ссылка на картинку соответствующего товарного предложения. Недопустимо давать ссылку на "заглушку", т.е. на картинку где написано "картинка отсутствует" или на логотип магазина
# typePrefix  Группа товаров \ категория
# vendor  Производитель
# model  Модель
# name Наименование товарного предложения
# delivery  Элемент, обозначающий возможность доставить соответствующий товар. "false" данный товар не может быть доставлен("самовывоз"). "true" товар доставляется на условиях, которые указываются в партнерском интерфейсе http://partner.market.yandex.ru на странице "редактирование".
# description  Описание товарного предложения
# vendorCode  Код товара (указывается код производителя)
# local_delivery_cost  Стоимость доставки данного товара в Своем регионе
# available  Статус доступности товара - в наличии/на заказ
# available="false" - товарное предложение на заказ. Магазин готов осуществить поставку товара на указанных условиях в течение месяца (срок может быть больше для товаров, которые всеми участниками рынка поставляются только на заказ).. Те товарные предложения, на которые заказы не принимаются, не должны выгружаться в Яндекс.Маркет.
# available="true" - товарное предложение в наличии. Магазин готов сразу договариваться с покупателем о доставке товара
# sales_notes  Элемент, предназначенный для того, чтобы показать пользователям, чем отличается данный товар от других, или для описания акций магазина (кроме скидок). Допустимая длина текста в элементе - 50 символов.
# manufacturer_warranty  Элемент предназначен для отметки товаров, имеющих официальную гарантию производителя.
# country_of_origin  Элемент предназначен для указания страны производства товара.
# downloadable  Элемент предназначен обозначения товара, который можно скачать.
# Пример
# <?xml version="1.0" encoding="windows-1251"?>
# <!DOCTYPE yml_catalog SYSTEM "shops.dtd">
# <yml_catalog date="2009-05-01 14:30">
# <shop>
#   <name>vashmaster.ru</name>
#   <company>Ваш МАСТЕР – Создание и поддержка сайтов</company>
#   <url>http://vashmaster.ru/</url>

# <currencies><currency id="RUR" rate="1"/></currencies>

# <categories>
#   <category id="1" parentId="0">Создание сайтов</category>
#   <category id="2" parentId="1">Сайт-визитка</category>
#   <category id="3" parentId="1">Интернет-магазин</category>
# </categories>

# <offers>
#   <offer id="1" available="true">
#   <url>http://vashmaster.ru/sozdanie_saytov/?1</url>
#   <price>15000</price>
#   <currencyId>RUR</currencyId>
#   <categoryId>2</categoryId>
#   <picture></picture>
#   <delivery>false</delivery>
#   <name>Создание сайта-визитки</name>
#   <description>В услугу входит: разработка дизайна, вёрстка, программирование и наполнение 5 основных разделов (Главная, О компании, Услуги, Цены, Контакты)</description>
#   <sales_notes>Цена указана за сайт-визитку с разработкой одного варианта дизайна</sales_notes>
#   </offer>

#   <offer id="2" available="true">
#   <url>http://vashmaster.ru/sozdanie_saytov/?2</url>
#   <price>25000</price>
#   <currencyId>RUR</currencyId>
#   <categoryId>3</categoryId>
#   <picture></picture>
#   <delivery>false</delivery>
#   <name>Создание интернет-магазина</name>
#   <description>В услугу входит: разработка дизайна, вёрстка, программирование и наполнение основных разделов (Главная, О магазине, Доставка, Оплата, Гарантии, Контакты и 3-х описаний продукции)</description>
#   <sales_notes>Цена указана за интернет-магазин с минимальным функционалом и разработкой одного варианта дизайна</sales_notes>
#   </offer>
# </offers>
# </shop>
# </yml_catalog>
