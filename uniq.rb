#!/usr/bin/env ruby
$stdin.flush
$stdout.flush
$stdout.sync = true

e = File.readlines("all-wp-users.txt")
e.uniq!
f = File.open("filtered.txt", "w")

e.each do |line|
  f.puts(line)
end

f.close