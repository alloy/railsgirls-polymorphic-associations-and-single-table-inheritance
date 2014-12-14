class AddPurchasableColumnsToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :purchasable_type, :string
    add_column :invoices, :purchasable_id, :integer
  end
end
