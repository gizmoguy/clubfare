class AddHandpullToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :handpull, :boolean
  end
end
