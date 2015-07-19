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
# default every page returns 20 apps
apps = gps.search("bird")

# you can search next page app arrary
apps = gps.next_page # current page will be change to 2

# current page will be change to 3
apps = gps.next_page

# you can see current page (return page numer)
p gps.current_page # 3

# you can see current_page (return page numer)
p gps.kewyword # "bird"

# if you search another keyword use same instance
gps.search("tiger") # current page will be change to default 1

```

###Configuring
```ruby
gps = GooglePlaySearch::Search.new(:language=>"en", :category=>"apps",
                                   :price => 0, :rating => 1)
```
* `language`: search language. Default:en. (can be "en", "zh_CN", "ja", "ko", "fr")
* `category`: search category. Default:apps. (can be "apps","music","movies","books","magazines").
              some country don't support "music","movies","books","magazines" yet.
* `price`: app price. Default: "0" - All Price. Can be "1" - Free App. "2" -  need paid App.
* `rating`: rating search conditions. Default: "0" - All ratings. Can be "1" - "4 stars +" App

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

# Below are the details of app
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

# app developer website
app.developer_website

# app developer email
app.developer_email

# app developer address
app.developer_address

# app reviews (only 40 reviews)
app.reviews
#<GooglePlaySearch::Review
# @author_name="alex persohn",
# @author_avatar="https://lh6.googleusercontent.com/xxxxxxx/photo.jpg",
# @review_title="Was really fun, but keeps freezing.",
# @review_content="This is a really addicting game, but as of late the app keeps freezing. Every three games or so, it will freeze and I have to kill the app via task manager. It's some error in the app fetching the add, which just makes it even more frustrating. Would rate 5 stars if this didn't happen.",
# @star_rating= 1
```
### Note

As google play site have access limit. So if you use this gem search app very often.
Some times will return nothing.
