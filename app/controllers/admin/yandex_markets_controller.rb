class Admin::YandexMarketsController < Admin::BaseController  
  def index
   @taxons =  Taxon.roots
  end
end
