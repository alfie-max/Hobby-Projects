#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'

url = "http://static.cricinfo.com/rss/livescores.xml"

loop do
  begin
    open_url = open(url)
    if open_url.status[0].to_i == 200
      data = Nokogiri::XML(open_url.read)
      desc = data.xpath('//description')
      command = 'notify-send ' + '"' + desc[1].content + '"'
      system(command)
    end
    sleep(5)
  rescue Exception => error
    message = "Failed to fetch the score:  #{error}"
    command = 'notify-send ' + '"' + message + '"'
    system(command)
    sleep(15)
  end
end
