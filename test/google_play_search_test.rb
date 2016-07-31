require 'minitest/autorun'
require 'google_play_search'
require 'vcr'
require "minitest-vcr"

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end

MinitestVcr::Spec.configure!

describe GooglePlaySearch do
  describe "generic search" do
    before do
      @gps = GooglePlaySearch::Search.new
    end

    describe "#search", :vcr do
      it "should returns the apps" do
        apps = @gps.search("bird")
        assert_instance_of Array, apps
        assert_instance_of GooglePlaySearch::App, apps.first
        assert_equal @gps.current_page, 1
        next_apps = @gps.next_page
        assert_instance_of Array, next_apps
        assert_instance_of GooglePlaySearch::App, next_apps.first
        assert_equal @gps.current_page, 2
      end

      it "should return no apps when there are no results" do
        apps = @gps.search('qqqqqqqqqqqqqqqqqqqq')
        assert_instance_of Array, apps
        assert_empty apps
        assert_equal @gps.current_page, 1
      end

      it "rating should work" do
        @gps = GooglePlaySearch::Search.new({rating: "1"})
        apps = @gps.search("bird")
        apps.each do |app|
          assert_equal true, app.rating.to_f.round >= 4.0
        end
      end
    end
  end

  describe "movie search" do
    before do
      @gps = GooglePlaySearch::Search.new(:category => 'movies')
    end

    describe "#search", :vcr do
      it "should return movies" do
        apps = @gps.search("dark knight")
        assert_instance_of Array, apps
        assert_instance_of GooglePlaySearch::App, apps.first
        assert_equal @gps.current_page, 1
        next_apps = @gps.next_page
        assert_instance_of Array, next_apps
        assert_instance_of GooglePlaySearch::App, next_apps.first
        assert_equal @gps.current_page, 2
      end
    end
  end
end
