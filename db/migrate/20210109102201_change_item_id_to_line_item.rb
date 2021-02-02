class ChangeItemIdToLineItem < ActiveRecord::Migration[6.0]
  def change
    change_column :line_items, :item_id, :bigint, :null => true
  end
end
