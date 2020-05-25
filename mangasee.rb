require 'nokogiri'
require 'open-uri'
require 'pry'
require './ripper.rb'

class Mangasee < Ripper
  def initialize(url)
    parsed = Nokogiri::HTML.parse(open(url))
    @title = url[/read-online\/(.*)-page/, 1]
    num_pages = parsed.at_css(".PageSelect").children.last.attributes['value'].value.to_i
    gallery = parsed.at_css('.CurImage').attributes['src'].value
    @image_urls = 1.upto(num_pages).map do |i|
      gallery.gsub(/([0-9]+)(\.[a-z]+)$/, "#{i.to_s.rjust(3, '0')}\\2")
    end
  end

  def img_name(url)
    url[/-([0-9]+.*)$/, 1]
  end
end
