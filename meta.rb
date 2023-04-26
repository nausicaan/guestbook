#!/usr/bin/env ruby
$stdin.flush
$stdout.flush
$stdout.sync = true
arguments = ARGV

path = arguments[0]
server = arguments[1]

@olds = "["
@blanks = "["
@currents = "["

ids = File.readlines(Dir.home + "/filtered.txt")

def write_file(dest, bunch)
  open(Dir.home + "/#{dest}", 'w') do |f|
    f.print bunch
  end
end

rn = Time.now.to_i
ids.each do |line|
  line.chomp!
  t = %x[wp user meta get "#{line}" last_login --url="#{server}" --path="#{path}"]
  ts = t.to_i
  if ts == 0
    @blanks << '{"id":"' << "#{line}" << '","timestamp":"None Recorded"},'
  elsif rn - ts >= 31556926
    @olds << '{"id":"' << "#{line}" << '","timestamp":"' << "#{ts}" << '"},'
  else @currents << '{"id":"' << "#{line}" << '","timestamp":"' << "#{ts}" << '"},'
  end
end

@olds.chop!
@blanks.chop!
@currents.chop!

if @olds.empty? == false
  @olds << ']'
elsif @blanks.empty? == false
  @blanks << ']'
end

@currents << ']'

write_file("olds.json", @olds)
write_file("blanks.json", @blanks)
write_file("currents.json", @currents)