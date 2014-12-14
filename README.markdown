# Generate base application

```
$ rails new railsgirls-event-tickets
$ cd railsgirls-event-tickets
```

```
$ bundle exec rails generate scaffold sport_event starts_at:datetime ends_at:datetime ticket_price:integer home_team:string away_team:string
$ bundle exec rails generate scaffold music_event starts_at:datetime ends_at:datetime ticket_price:integer band:string
$ bundle exec rails generate scaffold invoice customer:string
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



# Add various sports models through Single-Table Inheritance

Single-table inheritance, also known as STI, is a technique that allows multiple models with similar
data sets share the same database table. What’s more, is that these models can be subclasses of the
main table model and thus have specialized behaviour.

In the case of soccer and basketball sport events, they both have the concept of teams, but both
with their own unique sets of teams.

We’ll get back to this at the end of this exercise, but first let’s make the basics work.

## Create the subclass models

Add the `type` column to the `sport_events` table, which will hold the type of sport event for each
row. Rails will automatically store the type based on the subclass being used.

```
$ bundle exec rails generate migration AddTypeToSportEvent type:string
$ bundle exec rake db:migrate
```

Add model files for soccer and basketball events.

```
$ echo -e "class SoccerEvent < SportEvent\nend" > app/models/soccer_event.rb
$ echo -e "class BasketballEvent < SportEvent\nend" > app/models/basketball_event.rb
```

## Fix URLs/paths that are inflected from the sport event type

Because now a `@soccer_event` may be a `SoccerEvent` or a `BasketballEvent`, this will lead to in
cases where figuring out the type is left up to the `url_for` helper. To fix this, these occurrences
need to be made explicit.

----

### `app/views/sport_events/edit.html.erb`

```diff
@@ -2,5 +2,5 @@
 
 <%= render 'form' %>
 
-<%= link_to 'Show', @sport_event %> |
+<%= link_to 'Show', sport_event_path(@sport_event) %> |
 <%= link_to 'Back', sport_events_path %>
```

----

### `app/views/sport_events/index.html.erb`

```diff
@@ -20,9 +20,9 @@
         <td><%= sport_event.ticket_price %></td>
         <td><%= sport_event.home_team %></td>
         <td><%= sport_event.away_team %></td>
-        <td><%= link_to 'Show', sport_event %></td>
+        <td><%= link_to 'Show', sport_event_path(sport_event) %></td>
         <td><%= link_to 'Edit', edit_sport_event_path(sport_event) %></td>
-        <td><%= link_to 'Destroy', sport_event, method: :delete, data: { confirm: 'Are you sure?' } %></td>
+        <td><%= link_to 'Destroy', sport_event_path(sport_event), method: :delete, data: { confirm: 'Are you sure?' } %></td>
       </tr>
     <% end %>
   </tbody>
```

----

### `app/views/sport_events/_form.html.erb`

```diff
@@ -1,4 +1,4 @@
-<%= form_for(@sport_event) do |f| %>
+<%= form_for(@sport_event, :url => (@sport_event.new_record? ? sport_events_url : sport_event_url(@sport_event) )) do |f| %>
   <% if @sport_event.errors.any? %>
     <div id="error_explanation">
       <h2><%= pluralize(@sport_event.errors.count, "error") %> prohibited this sport_event from being saved:</h2>
```

----

### `app/controllers/sport_events_controller.rb`

```diff
@@ -28,7 +28,7 @@ class SportEventsController < ApplicationController
 
     respond_to do |format|
       if @sport_event.save
-        format.html { redirect_to @sport_event, notice: 'Sport event was successfully created.' }
+        format.html { redirect_to sport_event_url(@sport_event), notice: 'Sport event was successfully created.' }
         format.json { render :show, status: :created, location: @sport_event }
       else
         format.html { render :new }
@@ -42,7 +42,7 @@ class SportEventsController < ApplicationController
   def update
     respond_to do |format|
       if @sport_event.update(sport_event_params)
-        format.html { redirect_to @sport_event, notice: 'Sport event was successfully updated.' }
+        format.html { redirect_to sport_event_url(@sport_event), notice: 'Sport event was successfully updated.' }
         format.json { render :show, status: :ok, location: @sport_event }
       else
         format.html { render :edit }
```

----

## Make creating and editing soccer and basketball events work.

Now that we all the views are usable again, it’s time to make sure that the right type of sport
event is created and edited.

The important thing to note here is that instead of using the `SportEvent` class, the application
should now use the subclass for the specific sport event type that is being worked on.

----

### `app/views/sport_events/index.html.erb`

```diff
@@ -30,4 +30,5 @@
 
 <br>
 
-<%= link_to 'New Sport event', new_sport_event_path %>
+<%= link_to 'New soccer event', new_sport_event_path(:sport_event => { :type => 'SoccerEvent' }) %>
+<%= link_to 'New basketball event', new_sport_event_path(:sport_event => { :type => 'BasketballEvent' }) %>
```

----

### `app/controllers/sport_events_controller.rb`

```diff
@@ -14,7 +14,7 @@ class SportEventsController < ApplicationController
 
   # GET /sport_events/new
   def new
-    @sport_event = SportEvent.new
+    @sport_event = sport_event_class.new
   end
 
   # GET /sport_events/1/edit
@@ -24,7 +24,7 @@ class SportEventsController < ApplicationController
   # POST /sport_events
   # POST /sport_events.json
   def create
-    @sport_event = SportEvent.new(sport_event_params)
+    @sport_event = sport_event_class.new(sport_event_params)
 
     respond_to do |format|
       if @sport_event.save
@@ -62,6 +62,14 @@ class SportEventsController < ApplicationController
   end
 
   private
+    # Use the appropriate SportEvent subclass.
+    #
+    # String#constantize turns a string like `SoccerEvent` into a class of the same name, if it exists.
+    #
+    def sport_event_class
+      params[:sport_event][:type].constantize
+    end
+
     # Use callbacks to share common setup or constraints between actions.
     def set_sport_event
       @sport_event = SportEvent.find(params[:id])
```

----

### `app/views/sport_events/_form.html.erb`

```diff
@@ -1,4 +1,4 @@
-<%= form_for(@sport_event, :url => (@sport_event.new_record? ? sport_events_url : sport_event_url(@sport_event) )) do |f| %>
+<%= form_for(@sport_event, :as => :sport_event, :url => (@sport_event.new_record? ? sport_events_url : sport_event_url(@sport_event) )) do |f| %>
   <% if @sport_event.errors.any? %>
     <div id="error_explanation">
       <h2><%= pluralize(@sport_event.errors.count, "error") %> prohibited this sport_event from being saved:</h2>
@@ -11,6 +11,8 @@
     </div>
   <% end %>
 
+  <%= f.hidden_field :type %>
+
   <div class="field">
     <%= f.label :starts_at %><br>
     <%= f.datetime_select :starts_at %>
```

----

## Show sport event type to user in views.

Now that the application is working functionally, it’s a good idea to improve the interface a bit by
clarifying what type of sport event a given event is.

----

### `app/views/sport_events/index.html.erb`

```diff
@@ -5,6 +5,7 @@
     <tr>
       <th>Starts at</th>
       <th>Ends at</th>
+      <th>Type</th>
       <th>Ticket price</th>
       <th>Home team</th>
       <th>Away team</th>
@@ -17,6 +18,7 @@
       <tr>
         <td><%= sport_event.starts_at %></td>
         <td><%= sport_event.ends_at %></td>
+        <td><%= sport_event.type.sub('Event', '') %></td>
         <td><%= sport_event.ticket_price %></td>
         <td><%= sport_event.home_team %></td>
         <td><%= sport_event.away_team %></td>
```

----

### `app/views/sport_events/show.html.erb`

```diff
@@ -1,5 +1,7 @@
 <p id="notice"><%= notice %></p>
 
+<h1><%= @sport_event.type.underscore.humanize %></h1>
+
 <p>
   <strong>Starts at:</strong>
   <%= @sport_event.starts_at %>
```

----

### `app/views/sport_events/new.html.erb`

```diff
@@ -1,4 +1,4 @@
-<h1>New sport_event</h1>
+<h1>New <%= @sport_event.type.underscore.sub('_', ' ') %></h1>
 
 <%= render 'form' %>
```

----

### `app/views/sport_events/edit.html.erb`

```diff
@@ -1,4 +1,4 @@
-<h1>Editing sport_event</h1>
+<h1>Editing <%= @sport_event.type.underscore.sub('_', ' ') %></h1>
 
 <%= render 'form' %>
```

----

## Add soccer and basketball teams and show in selection popups.

Up to now, this exercise has mainly been an academic one. Besides differentiating between the types
of sport events and showing that type in the interface, the use of STI has not really done much more
for us, and has, arguably, only lead to more complex code. But now it’s time to change that.

Let’s add the sets of teams to their respective subclasses and show them in the interface.

----

### `app/models/basketball_event.rb`

```diff
@@ -1,2 +1,36 @@
 class BasketballEvent < SportEvent
+  def self.teams
+    [
+      "Atlanta Hawks",
+      "Boston Celtics",
+      "Brooklyn Nets",
+      "Charlotte Hornets",
+      "Chicago Bulls",
+      "Cleveland Cavaliers",
+      "Dallas Mavericks",
+      "Denver Nuggets",
+      "Detroit Pistons",
+      "Golden State Warriors",
+      "Houston Rockets",
+      "Indiana Pacers",
+      "Los Angeles Clippers",
+      "Los Angeles Lakers",
+      "Memphis Grizzlies",
+      "Miami Heat",
+      "Milwaukee Bucks",
+      "Minnesota Timberwolves",
+      "New Orleans Pelicans",
+      "New York Knicks",
+      "Oklahoma City Thunder",
+      "Orlando Magic",
+      "Philadelphia 76ers",
+      "Phoenix Suns",
+      "Portland Trail Blazers",
+      "Sacramento Kings",
+      "San Antonio Spurs",
+      "Toronto Raptors",
+      "Utah Jazz",
+      "Washington Wizards"
+    ]
+  end
 end
```

----

### `app/models/soccer_event.rb`

```diff
@@ -1,2 +1,24 @@
 class SoccerEvent < SportEvent
+  def self.teams
+    [
+      "ADO Den Haag",
+      "AZ",
+      "Ajax",
+      "Excelsior",
+      "FC Dordrecht",
+      "FC Groningen",
+      "FC Twente",
+      "FC Utrecht",
+      "Feyenoord",
+      "Go Ahead Eagles",
+      "Heracles Almelo",
+      "NAC Breda",
+      "PEC Zwolle",
+      "PSV",
+      "SC Cambuur",
+      "SC Heerenveen",
+      "Vitesse",
+      "Willem II"
+    ]
+  end
 end
```

----

### `app/views/sport_events/_form.html.erb`

```diff
@@ -27,11 +27,11 @@
   </div>
   <div class="field">
     <%= f.label :home_team %><br>
-    <%= f.text_field :home_team %>
+    <%= f.select :home_team, @sport_event.class.teams %>
   </div>
   <div class="field">
     <%= f.label :away_team %><br>
-    <%= f.text_field :away_team %>
+    <%= f.select :away_team, @sport_event.class.teams %>
   </div>
   <div class="actions">
     <%= f.submit %>
```

----



# Make sport and music events purchasable through a Polymorphic Association.

To be able to purchase a ticket for either a sport or music event, the application will have to be
able to associate the event to an invoice. A very simple example of how to achieve this would be:

```ruby
class Invoice < ActiveRecord::Base
  belongs_to :sport_event
  belongs_to :music_event
end
```

_NOTE: It might seem counter-intuitive to define this as a `belongs_to` association, but the key
point here is that, with a `belongs_to` association, the foreign key (the ID of the associated model
record) is on this model._

While this would work, and simplicity should never be underestimated, it does not scale well once
you might start selling tickets for other types of events in the future.

Essentially, an invoice should be able to associate to _any_ type of event. This is where
polymorphic associations come into play.

A polymorphic association is an association that is able to associate a model to any other type of
model. To do this, the model will need to hold both ther foreign key to the associated model record
_and_ its type.

## Add the polymorphic association columns to the invoices table and configure the model.

In this example, a polymorphic association is added with the abstract name `purchasable`, which will
represent either a music, soccer, or basketball event.

```
$ bundle exec rails generate migration AddPurchasableColumnsToInvoice purchasable_type:string purchasable_id:integer
$ bundle exec rake db:migrate
```

And the `app/models/invoice.rb` file is updated to look like:

```ruby
class Invoice < ActiveRecord::Base
  belongs_to :purchasable, :polymorphic => true
end
```
