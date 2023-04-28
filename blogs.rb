#!/usr/bin/env ruby
$stdin.flush
$stdout.flush
$stdout.sync = true
@raw = "["

e = File.read("blogs.txt")
h = e.split(",")

def scribble(dest, bunch)
  open(Dir.home + "/#{dest}", 'w') do |f|
    f.print bunch
  end
end

index = 0
while index < h.length() do
  @raw << '{"URL": "' << "#{h[index]}" << '"},'
  index += 1
  @raw << '{"ID": ' << "#{h[index]}" << '},'
  index += 1
end

@raw.chop!
@raw << "]"
scribble("blogs.json", @raw)