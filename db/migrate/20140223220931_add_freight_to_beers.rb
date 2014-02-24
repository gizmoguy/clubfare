class AddFreightToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :freight, :float
  end
end
