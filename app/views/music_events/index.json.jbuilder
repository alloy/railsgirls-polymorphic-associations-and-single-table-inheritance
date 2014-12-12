json.array!(@music_events) do |music_event|
  json.extract! music_event, :id, :starts_at, :ends_at, :ticket_price, :band
  json.url music_event_url(music_event, format: :json)
end
