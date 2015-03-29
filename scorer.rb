#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'

break_interval = {
  'ok' => 5,
  'error' => 15
}

def get_score(url)
  loop do
    open_url = open(url)
    if open_url.status.last == 'OK'
      data = Nokogiri::XML(open_url.read)
      desc = data.xpath('//description')
      return desc[1].content
    end
    take_a_break break_interval['error']
  end
end

def notify(message)
  command = 'notify-send ' + '"' + message + '"'
  system(command)
end

def take_a_break(seconds, error=false)
  begin
    sleep(seconds)
  rescue SystemExit, Interrupt
    byebye if error
    raise SystemExit
  end
end

def byebye
  puts "\b\bBye Bye... See you for the next match"
end


url = "http://static.cricinfo.com/rss/livescores.xml"

begin
  loop do
    score = get_score(url)
    notify score if score
    take_a_break break_interval['ok']
  end
rescue SystemExit, Interrupt
  byebye
rescue Exception => error
  notify "Failed to fetch the score:  #{error}"
  take_a_break(break_interval['error'], true)
  retry
end
