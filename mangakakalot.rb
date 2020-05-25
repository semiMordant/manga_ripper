require 'nokogiri'
require 'open-uri'

require './ripper.rb'

class Mangakakalot < Ripper
  def initialize(url)
    parsed = Nokogiri::HTML.parse(open(url))
    @title = parsed.xpath("//h2")[0].text
    gallery = url.split('/')[-2]
    @image_urls = parsed.xpath("//img").map {|v| v.attributes['src'].value}.select do |v|
      v.include? gallery
    end
  end
end
