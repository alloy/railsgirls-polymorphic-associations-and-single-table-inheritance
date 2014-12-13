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

```
$ bundle exec rails generate migration AddTypeToSportEvent type:string
$ bundle exec rake db:migrate
```

Add model files for soccer and basketball events:

```
$ echo -e "class SoccerEvent < SportEvent\nend" > app/models/soccer_event.rb
$ echo -e "class BasketballEvent < SportEvent\nend" > app/models/basketball_event.rb
```

## Fix URLs/paths that are inflected from the sport event type

Because now a `@soccer_event` may be a `SoccerEvent` or a `BasketballEvent`, this will lead to in
cases where figuring out the type is left up to the `url_for` helper. To fix this, these occurrences
need to be made explicit.

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

## Make creating and editing soccer and basketball events work.

Now that we all the views are usable again, it’s time to make sure that the right type of sport
event is created and edited.

The important thing to note here is that instead of using the `SportEvent` class, the application
should now use the subclass for the specific sport event type that is being worked on.

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

### `app/views/sport_events/index.html.erb`

```diff
@@ -30,4 +30,5 @@
 
 <br>
 
-<%= link_to 'New Sport event', new_sport_event_path %>
+<%= link_to 'New soccer event', new_sport_event_path(:sport_event => { :type => 'SoccerEvent' }) %>
+<%= link_to 'New basketball event', new_sport_event_path(:sport_event => { :type => 'BasketballEvent' }) %>
```

----

