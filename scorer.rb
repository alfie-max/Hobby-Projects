#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'

def notify(message)
  command = 'notify-send ' + '"' + message + '"'
  system(command)
end

def byebye
  puts "\b\bBye Bye... See you for the next match"
end

def take_a_break(seconds)
  begin
    sleep(seconds)
  rescue SystemExit, Interrupt
    byebye
    raise SystemExit
  end
end


url = "http://static.cricinfo.com/rss/livescores.xml"

begin
  loop do
    open_url = open(url)
    if open_url.status[0].to_i == 200
      data = Nokogiri::XML(open_url.read)
      desc = data.xpath('//description')
      notify desc[1].content
    end
    take_a_break 5
  end
rescue SystemExit, Interrupt
  byebye
rescue Exception => error
  err_msg = "Failed to fetch the score:  #{error}"
  notify err_msg
  take_a_break 15
  retry
end
