class CreateSportEvents < ActiveRecord::Migration
  def change
    create_table :sport_events do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :ticket_price
      t.string :home_team
      t.string :away_team

      t.timestamps
    end
  end
end
