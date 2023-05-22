#!/usr/bin/env ruby
$stdin.flush
$stdout.flush
$stdout.sync = true
arguments = ARGV

path, home = arguments[0], arguments[1]
sites = File.readlines("#{home}sites.txt")

open("#{arguments[1]}all-wp-users.txt", 'w') do |f|
  sites.each do |line|
    bulk = %x[wp user list --url="#{line}" --path="#{path}" --fields=ID --skip-plugins=photo-gallery --format=csv]
    f.print "#{bulk}"
  end
end