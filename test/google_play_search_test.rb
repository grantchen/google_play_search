require 'minitest/autorun'
require 'google_play_search'

describe GooglePlaySearch do
  before do
    @gps = GooglePlaySearch::Search.new
  end

  describe "#search" do
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

    it "rating should work" do
      @gps = GooglePlaySearch::Search.new({rating: "1"})
      apps = @gps.search("bird")
      apps.each do |app|
        assert_equal true, app.rating.to_f.round >= 4.0
      end
    end
  end
end
