Gem::Specification.new do |s|
  s.name        = 'google_play_search'
  s.version     = '0.0.12'
  s.date        = '2015-05-25'
  s.summary     = "google play market search"
  s.description = "google play market search gem"
  s.authors     = ["Grant Chen"]
  s.email       = 'kucss@hotmail.com'
  s.license     = 'MIT'

  s.add_runtime_dependency('nokogiri','~> 1.5')

  s.files         = Dir['lib/**/*.rb'] + Dir['*.rb']
  s.homepage    =
    'https://github.com/grantchen/google_play_search'
end
