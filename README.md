google_play_search is a Ruby gem that provides search functions in google play store.

### Installation

```sh
$ gem install google_play_search
```

Or with Bundler in your Gemfile.

```ruby
gem 'google_play_search'
```

### Usage

```ruby
# only 1.8.7 need this
require 'rubygems'

require 'google_play_search'

gps = GooglePlaySearch::Search.new

# it will return app arrary.
# default every page returns 50 apps
apps = gps.search("bird")

# you can see current_page (return page numer)
p gps.kewyword # "bird"

```

### Configuring

```ruby
gps = GooglePlaySearch::Search.new(:language=>"en", :category=>"apps",
                                   :price => 0, :rating => 1)
```
* `language`: search language. Default:en. (can be "en", "zh_CN", "ja", "ko", "fr")
* `category`: search category. Default:apps. (can be "apps","music","movies","books","magazines").
              some country don't support "music","movies","books","magazines" yet.
* `price`: app price. Default: "0" - All Price. Can be "1" - Free App. "2" -  need paid App.
```

### Search Result

```ruby
# default return 50 records
app_list = gps.search("bird")

app = app_list.first

# android app id (like "com.rovio.angrybirds")
app.id

# android app name (like "Angry Birds")
app.name

# android app url (like "https://play.google.com/store/apps/details?id=com.rovio.angrybirds")
app.url

# android app developer (like "Rovio Mobile Ltd.")
app.developer

# android app logo url (like
# "https://lh3.ggpht.com/6c2H-PDJk5Sax4WaIiTQgovdqvfNZZbtoQyktOgd_uW-Hh09idFdej14LPqalvVz9LA=w78-h78")
app.logo_url

# android app short description
# (like "Use the unique powers of the Angry Birds to destroy the greedy pigs' fortresses!
#  The survival of the Angry Birds is at stake. Dish out revenge on the greedy pigs who s...")
app.short_description

# android app average review rating (like 4.6)
# type is float
app.rating

# android app price (like "$2.99")
# type is string
app.price

```

### Note

As google play site have access limit. So if you use this gem search app very often.
Some times will return nothing.
