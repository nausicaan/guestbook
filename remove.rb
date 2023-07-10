#!/usr/bin/env ruby
$stdin.flush
$stdout.flush
$stdout.sync = true
arguments = ARGV
require 'json'

p1 = File.read('zeros.json')
p2 = File.read('sites.json')
people = JSON.parse(p1)
places = JSON.parse(p2)

@path, @server, @uid = arguments[0], arguments[1], ""

# Write a passed variable to a named file
def scribble(bunch)
  open(Dir.home + "/for-deletion.txt", 'a') do |f|
    f.puts bunch
  end
end

# Filter down the grepped information to only blog_id's
def isolate(bulk)
  triage = []
  collection = bulk.split(',')
  collection.each do |line|
    if "#{line}".include? "_user_level"
      line.sub!("wp_", "")
      line.sub!("_user_level", "")
      line.chomp!
      triage << "#{line}"
    end
  end
  return triage
end

# Main body of the program
people.each do |line|
  @uid = "#{line['ID']}"
  bls = %x[wp user meta list "#{line['ID']}" --url="#{@server}" --path="#{@path}" --format=csv | grep wp_]
  bls.gsub!("\n" , ",")
  splat = isolate(bls)
  splat.each do |nums|
    places.each do |urls|
      if nums == urls['blog_id']
        $stdout.puts %x[wp user delete "#{@uid}" --reassign=31 --url="#{urls['url']}" --path="#{@path}"]
      end
    end
  end
end