# encoding: utf-8
require 'mechanize'

def parse_page(url)
  options = {:title => "", :description => "", :image => "", :url => url}

  begin
    unless url =~ /(http|https)\:\/\//i
      url = "http://#{url}"
    end

    mechanize = Mechanize.new
    page = mechanize.get(url)

    title = page.title
    unless title
      title = page.at("head meta[property='og:title']")
      title = title["content"] if title
    end

    desc = page.at("head meta[name='description']")
    if desc
      desc = desc["content"]
    else
      desc = page.at("head meta[property='og:description']")
      desc = desc["content"] if desc
    end

    image = page.at("head meta[property='og:image']")
    if image
      image = image["content"]
    end

    options[:title] = title
    options[:description] = desc
    options[:image] = image
  rescue Exception => ex
    puts "ERROR: #{ex.message}"
  end
  return options
end
