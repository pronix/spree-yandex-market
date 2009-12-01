require File.dirname(__FILE__) + '/../spec_helper'

describe YandexMarketController do

  #Delete this example and add some real ones
  it "should use YandexMarketController" do
    controller.should be_an_instance_of(YandexMarketController)
  end

  describe 'route generation' do 
    it 'should generate correct routes' do
      route_for(:controller => 'yandex_market', :action => 'index', :method => :get).should == "/yandex_market"
    end  
  end
  
  describe 'route recognition' do
    it 'should generate params {:controller => "yandex_market", :action => "index"} from GET /yandex_market' do
      params_from(:get, '/yandex_market').should == {:controller => 'yandex_market', :action => 'index', :method => :get}
    end
  end
  
  describe "YandexMarket, Get INDEX" do 
    it "should get product for export"
    it "should send file"
  end
end
