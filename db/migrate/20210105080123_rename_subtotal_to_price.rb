class RenameSubtotalToPrice < ActiveRecord::Migration[6.0]
  def change
    rename_column :line_items, :subtotal, :price
  end
end
