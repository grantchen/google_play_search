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
gps = GooglePlaySearch::Search.new(:language=>"en", :category=>"apps", :per_page_num=>10)
```
* `language`: search language. Default:en. (can be "en", "zh_CN", "ja", "ko", "fr") 
* `category`: search category. Default:apps. (can be "apps")
* `per_page_num`: app numbers in every page of search result. Default: 24

###Search Result
```ruby
app_list = gps.search("bird")

# android app id (like "com.rovio.angrybirds")
p app_list[0].id

# android app name (like "Angry Birds")
p app_list[0].name

# android app url (like "https://play.google.com/store/apps/details?id=com.rovio.angrybirds")
p app_list[0].url

# android app developer (like "Rovio Mobile Ltd.")
p app_list[0].developer

# android app category (like "Arcade & Action")
p app_list[0].category

# android app logo url (like "https://lh3.ggpht.com/6c2H-PDJk5Sax4WaIiTQgovdqvfNZZbtoQyktOgd_uW-Hh09idFdej14LPqalvVz9LA=w78-h78")
p app_list[0].logo_url

# android app short description
# (like "Use the unique powers of the Angry Birds to destroy the greedy pigs' fortresses! The survival of the Angry 
#  Birds is at stake. Dish out revenge on the greedy pigs who s...")
p app_list[0].short_description

```