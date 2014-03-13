class AddHandpullToFormats < ActiveRecord::Migration
  def change
    add_column :formats, :handpull, :boolean
  end
end
