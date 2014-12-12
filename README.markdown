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

# Setup

Change into project directory, if you have not done so already:

```
$ cd railsgirls-event-tickets
```

```
$ bundle install
$ bundle exec rake db:migrate
```
