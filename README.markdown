# RailsGirls: Polymorphic Associations and Single-Table Inheritance

This repository contains the base application for the similarly named
[RailsGirls event](http://www.meetup.com/RailsGirls-NL/events/197905392/).

# Prerequisite

* Ruby 2 installed. The latest version is 2.1.5, but any 2.x.x version will do.
* Ruby sqlite3 gem installed.
* Ruby bundler gem installed.

# Installation

```
$ git clone https://github.com/alloy/railsgirls-polymorphic-associations-and-single-table-inheritance.git
$ cd railsgirls-polymorphic-associations-and-single-table-inheritance
```

```
$ bundle install
$ bundle exec rake db:migrate
```

```
$ bundle exec rails server
```

Open web browser at http://0.0.0.0:3000.

