#!/usr/bin/env ruby

key = ARGV[0]
cipher = ARGV[1]

if !(key and cipher)
  puts 'Please provide required fields'
  exit
end

key_chars = key.chars.uniq
all_chars = key_chars + (('A'..'Z').to_a - key_chars)

group_chars = all_chars.each_slice(key_chars.length).to_a
chars = group_chars.first.zip(*group_chars[1..-1]).sort_by(&:first).flatten!

chars.delete(nil) while chars.include? nil
char_map = Hash[chars.zip(('A'..'Z').to_a)]
# char_map[' '] = ' '     # Uncomment to include spaces

puts cipher.chars.map{|c| char_map[c]}.join
