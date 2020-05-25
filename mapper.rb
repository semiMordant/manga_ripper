require './mangakakalot.rb'
require './mangasee.rb'
require './nhentai.rb'

MAP = {
  'https://mangakakalot.com/chapter/' => Mangakakalot,
  'https://mangaseeonline.us/read-online' => Mangasee,
  'https://nhentai.net/g/' => NHentai
}

zip = ARGV.any? {|arg| arg == '-z' || arg == '--zip'}
ARGV.each do |url|
  m = MAP.find{|k,v| url.start_with? k}
  continue unless m
  ripper = m[1].new(url)
  puts "Ripping #{ripper.title}"
  ripper.rip(zip)
end
