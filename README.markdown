# Generate base application

```
$ rails new railsgirls-event-tickets
$ cd railsgirls-event-tickets
```

```
$ rails generate scaffold sport_event starts_at:datetime ends_at:datetime ticket_price:integer home_team:string away_team:string
$ rails generate scaffold music_event starts_at:datetime ends_at:datetime ticket_price:integer band:string
$ rails generate scaffold invoice customer:string
```

### Change root route to point to something:

```
$ edit config/routes.rb
```

```ruby
Rails.application.routes.draw do
  resources :invoices
  resources :music_events
  resources :sport_events

  root 'sport_events#index'
end
```

### Change view layout to add links to all sections

```
$ edit app/views/layouts/application.html.erb
```

```erb
<div>
  <%= link_to 'Sport Events', sport_events_path %>
  <%= link_to 'Music Events', music_events_path %>
  <%= link_to 'Invoices', invoices_path %>
</div>
```

# Setup

Change into project directory, if you have not done so already:

```
$ cd railsgirls-event-tickets
```

```
$ bundle install
$ bundle exec rake db:migrate
```

```
$ bundle exec rails server
```

Open web browser at http://0.0.0.0:3000.
