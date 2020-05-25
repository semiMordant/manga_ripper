require 'nokogiri'
require 'open-uri'

require './ripper.rb'

class NHentai < Ripper
  def initialize(url)
    parsed = Nokogiri::HTML.parse(open(url))
    metas = parsed.xpath("//meta").collect { |meta|
      ar = meta.attributes.values.collect(&:value)
      {ar[0] => ar[1]}
    }.compact.reduce({}, :merge)
    @title = metas["name"]
    gallery_id = metas["image"][/\d+/]
    num_pages = parsed.at_css("div#info").children[7].children.text.split.first.to_i
    @image_urls = []
    for page in 1..num_pages
      @image_urls << "https://i.nhentai.net/galleries/#{gallery_id}/#{page}.jpg"
    end
  end

  def single_img(url)
    begin
      super(url)
    rescue OpenURI::HTTPError
      url = url[0..-4] + 'png'
      super(url)
    end
  end
end
