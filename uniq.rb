#!/usr/bin/env ruby
$stdin.flush
$stdout.flush
$stdout.sync = true
arguments = ARGV

read = arguments[0]
write = arguments[1]

e = File.readlines("#{read}")
e.uniq!
f = File.open("#{write}", "w")

e.each do |line|
  f.puts(line)
end

f.close