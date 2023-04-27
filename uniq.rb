#!/usr/bin/env ruby
$stdin.flush
$stdout.flush
$stdout.sync = true
arguments = ARGV

read = arguments[0]
write = arguments[1]

n = []
e = File.readlines("#{read}")
f = File.open("#{write}", "w")
e.uniq!

e.each do |line|
  n << line.to_i
end

n.sort!
n.delete(0)

n.each do |line|
  f.puts(line)
end

f.close