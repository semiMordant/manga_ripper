require 'fileutils'
require 'open-uri'
require 'zip'

class Ripper
  def initialize(url) end

  def rip(zip = false)
    files = img_urls.map {|url| single_img(url)}
    zip ? zipem(files) : direm(files) unless files.empty?
  end

  def title
    @title
  end

  def img_name(url)
    url.split('/').last
  end

  def img_urls
    @image_urls
  end

  def single_img(url)
    puts img_name(url)
    [img_name(url), open(url).read]
  end

  private

  def zipem(files)
    stream = Zip::OutputStream.write_buffer do |buffer|
      files.each do |file|
          buffer.put_next_entry(file[0])
          buffer.write(file[1])
      end
      buffer.put_next_entry('title.txt')
      buffer.write(title)
    end
    open("#{title}.zip", 'w') { |zip| zip << stream.string }
  end

  def direm(files)
    Dir.mkdir title unless Dir.exist? @title
    files.each do |file|
      open("./#{@title}/#{file[0]}", 'w') { |w| w << file[1] }
    end
    open("./#{@title}/title.txt", 'w') { |w| w << title }
  end
end
