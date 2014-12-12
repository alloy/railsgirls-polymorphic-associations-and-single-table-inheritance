class AddTypeToSportEvent < ActiveRecord::Migration
  def change
    add_column :sport_events, :type, :string
  end
end
