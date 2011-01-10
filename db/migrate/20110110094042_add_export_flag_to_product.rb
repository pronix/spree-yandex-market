class AddExportFlagToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :export_to_yandex_market, :boolean, :default=>true, :null=>false
  end

  def self.down
    remove_column :products, :export_to_yandex_market
  end
end
