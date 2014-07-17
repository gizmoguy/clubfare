class ChangeFormatsSizeToFloat < ActiveRecord::Migration
  def change
    change_column :formats, :size, :float
  end
end
