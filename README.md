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

# it will return app arrary. default is first page
# default every page returns 24 apps
gps.search("bird")

# you can search next page app arrary
gps.next_page # current page will be change to 2

# you also can search the page what you want
gps.search("bird", :page => 3)
gps.next_page # current page will be change to 4

# you can see current page (return page numer)
p gps.current_page # 4

# you can see current_page (return page numer)
p gps.kewyword # "bird"

# if you search another keyword use same instance
gps.search("tiger") # current page will be change to default 1

```

###Configuring
```ruby
gps = GooglePlaySearch::Search.new(:language=>"en", :category=>"apps", :per_page_num=>10,
                                   :price => 0, :safe_search => 0, :sort_by => 1)
```
* `language`: search language. Default:en. (can be "en", "zh_CN", "ja", "ko", "fr")
* `category`: search category. Default:apps. (can be "apps","music","movies","books","magazines").
              some country don't support "music","movies","books","magazines" yet.
* `per_page_num`: app numbers in every page of search result. Default: 24
* `price`: app price. Default: "0" - All Price. Can be "1" - Free App. "2" -  need paid App.
* `safe_search`: search safe mode. Default: "0" - search safe off. Can be "1" - low safe mode.
                 "2" - moderate safe mode. "3" - strict safe mode .
* `sort_by`: app list sort by. Default: "1" - sort by Relevance. Can be "0" - sort by popularity

###Search Result
```ruby
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

# also you can get app version, installs, last updated and other details
app.get_all_details

# android app version (like '1.9.5')
app.version

# android app last updated (like '19 December 2014')
app.last_updated

# android app installs (like '5,000,000 - 10,000,000')
app.installs

# android app size (like '15M')
app.size

# android app require android version (like '2.3 and up')
app.requires_android

# android app content rating (like 'Everyone')
app.content_rating

# app category (like 'Arcade')
app.category
```
### Note

As google play site have access limit. So if you use this gem search app very often.
Some times will return nothing.
