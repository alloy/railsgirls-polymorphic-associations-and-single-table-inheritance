json.array!(@sport_events) do |sport_event|
  json.extract! sport_event, :id, :starts_at, :ends_at, :ticket_price, :home_team, :away_team
  json.url sport_event_url(sport_event, format: :json)
end
