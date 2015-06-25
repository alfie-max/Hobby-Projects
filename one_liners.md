# One-liners

### Reverse every line:

Input file:

    $ cat foo
    qwe
    123
    bar

Reverse file lines:

    $ ruby -e 'File.open("foo").each_line { |l| puts l.chop.reverse }'
    ewq
    321
    rab

Reverse lines from stdout:

    cat foo | ruby -e 'while s = gets; puts s.chop.reverse; end'

Reverse both (`ARGF == $<`):

    cat foo | ruby -e 'ARGF.each_line { |l| puts l.chop.reverse }'
    ruby -e 'ARGF.each_line { |l| puts l.chop.reverse }' foo

Let Ruby iterate for you:

    ruby -ne 'puts $_.chop.reverse' foo

Let Ruby print for you (clumsy):

    ruby -pe '$_.chop!.reverse!; $_ += "\n"' foo

Let Ruby chop for you:

    ruby -lpe '$_.reverse!' foo

In-place file editing:

    $ cat foo
    qwe
    123
    bar
    $ ruby -i -lpe '$_.reverse!' foo
    $ cat foo
    ewq
    321
    rab    

### Indent every line:

Just that:

    cat example.rb | ruby -ne 'puts " " * 4 + $_'

Or even that:

    ruby -ne 'puts " " * 4 + $_' example.rb

### Line numbering (all files at once):

    ruby -ne 'puts "#$. #$_"' foo.rb bar.rb

### Line numbering (per file file):

    ruby -ne '$. = 1 if $<.pos - $_.size == 0; puts "#$. #$_"' foo.rb bar.rb

### Count words:

    ruby -ane 'w = (w || 0) + $F.size; END { p w }' exmpl.txt

### Delete all consecutive blank lines from file except the first one in each group:

    ruby -ne 'puts $_ if /^[^\n]/../^$/'

### Extract all comments:

Input: 

    $ cat comments.txt 
    some code
    /*
      comment one
      comment two
    */
    more code
    /* one-line comment */
    a bit more code
    /*
      comment three
    */
    even more code

Ruby in action:

    $ ruby -ne 'puts $_ if ($_ =~ /^\/\*/)..($_ =~ /\*\/$/)' comments.txt
    /*
      comment one
      comment two
    */
    /* one-line comment */
    /*
      comment three
    */

Alternative:

    ruby -pe 'next unless ($_ =~ /^\/\*/)..($_ =~ /\*\/$/)' comments.txt

Homebrew flip-flop (from "The Ruby programming language" by David Flanagan, Yukihiro Matsumoto):

```ruby
# flip-flop.rb
$state = false
def flipflop(s)
  unless $state
    result = (s =~ /^\/\*$/)
    if result
      $state = !(s =~ /^\*\/$/)
    end 
    result
  else
    $state = !(s =~ /^\*\/$/)
    true
  end 
end

ARGF.each_line do |l| 
  puts l if flipflop(l)
end
```

Try it:
 
    ruby flip-flop.rb comments.txt

### Highlight trailing spaces:
     
    ruby -lpe '$_.gsub! /(\s+)$/, "\e[41m\\1\e[0m"' example.rb

### Remove trailing spaces:

    ruby -lpe '$_.rstrip!' example.rb

### For each line in the file highlights with red the part of it that goes over 50 characters:

Easy way:

    ruby -ne 'puts "#{$_}\e[31m#{$_.chop!.slice!(60..-1)}\e[0m"' example.rb

Uglier, but configurable:

    ruby -e 'w = $*.shift; $<.each { |l| puts "#{l}\e[31m#{l.chop!.slice!(w.to_i..-1)}\e[0m" }' 50 example.rb

### Simplest REPL:

   Straightforward one:

    ruby -e  'loop { puts eval(gets) }'

   Leverage -n option:
        
    ruby -ne 'puts eval($_)'

   Prompt (but not in the 1st line):

    ruby -ne 'print "#{eval($_).inspect}\n>> "'

   Fix it:

    ruby -ne 'BEGIN{print">> "}; print "#{eval($_).inspect}\n>> "'

   REPL should be polite:
            
    ruby -ne 'BEGIN{print">> "}; print "#{eval($_).inspect}\n>> "; END{puts "Bye"}'

   Handle RuntimeError (e.g., NameError), but not SyntaxError:

    ruby -ne 'BEGIN{print">> "}; print "#{(eval($_) rescue $!).inspect}\n>> "; END{puts "Bye"}'

   Rescue everything - save the world:

    ruby -ne 'BEGIN{print">> "}; print "#{(begin; eval($_); rescue Exception; $!; end).inspect}\n>> "; END{puts "Bye"}'

# Additions

Copyright in the beginning of every file:

```ruby
# copyright.rb
copyright = DATA.read

ARGF.each_line do |l|
  puts copyright if $. == 1
  puts l
end

__END__
####################################
# Copyright (C) 2012 Kirill Lashuk #
####################################

```

Use it:

    ruby copyright.rb foo.py > foo2.py

In place edit:

    ruby -i copyright.rb foo.py

Alternative:

```ruby
# copyright2.rb 
BEGIN { copyright = DATA.read }

puts copyright if $. == 1

__END__
####################################
# Copyright (C) 2012 Kirill Lashuk #
####################################

```
    
Use it (with backuping original file):

    $ cat bar.py
    print 'hello' 
    $ ruby -p -i.bak copyright2.rb bar.py
    $ cat bar.py
    ####################################
    # Copyright (C) 2012 Kirill Lashuk #
    ####################################
    
    print 'hello'
    $ cat bar.py.bak 
    print 'hello'

# Links

* [One-liners by Josh Cheek](https://github.com/JoshCheek/Play/blob/master/ruby-one-liners/Readme.md)
* [100 Ruby one-liners](http://www.fepus.net/ruby1line.txt)
* [Predefined global variables in Ruby](http://www.zenspider.com/Languages/Ruby/QuickRef.html#19)
* [ARGF doc](http://www.ruby-doc.org/core-1.9.2/ARGF.html)
* [Obscure and Ugly Perlisms in Ruby](http://blog.nicksieger.com/articles/2007/10/06/obscure-and-ugly-perlisms-in-ruby)