class CreateMusicEvents < ActiveRecord::Migration
  def change
    create_table :music_events do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :ticket_price
      t.string :band

      t.timestamps
    end
  end
end
