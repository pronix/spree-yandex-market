class Admin::YandexMarketsController < Admin::BaseController  
  before_filter :get_config
  
  def show
    @taxons =  Taxon.roots
    @config = YandexMarket.first
  end
  def category
    @taxons =  Taxon.roots
    @config = YandexMarket.first
  end
  def currency
    @config = YandexMarket.first    
  end
  
  def wares 
    @config = YandexMarket.first
  end
  
  def update
    @config = YandexMarket.first
    @config.attributes = params[:preferences]
    @config.save!
    
    respond_to do |format|
      format.html {
        redirect_to admin_yandex_markets_path
      }
    end
  end
  private
  def get_config
    @config = YandexMarket.first
  end
end
