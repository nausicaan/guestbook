#!/usr/bin/env ruby
$stdin.flush
$stdout.flush
$stdout.sync = true
arguments = ARGV

Trail = arguments[0]
Server = arguments[1]

@olds = "["
@blanks = "["
@goodies = "["

ids = File.readlines(Dir.home + "/filtered.txt")

def write_file(dest, bunch)
  open(Dir.home + "/#{dest}", 'w') do |f|
    f.print bunch
  end
end

rn = Time.now.to_i
ids.each do |line|
  line.chomp!
  t = %x[wp user meta get "#{line}" last_login --url="#{Server}" --path="#{Trail}"]
  ts = t.to_i
  if ts == 0
    @blanks << '{"id":"' << "#{line}" << '","timestamp":"None Recorded"},'
  elsif rn - ts >= 31556926
    @olds << '{"id":"' << "#{line}" << '","timestamp":"' << "#{ts}" << '"},'
  else @goodies << '{"id":"' << "#{line}" << '","timestamp":"' << "#{ts}" << '"},'
  end
end

@olds.chop!
@blanks.chop!
@goodies.chop!

if @olds.empty? == false
  @olds << ']'
elsif @blanks.empty? == false
  @blanks << ']'
end

@goodies << ']'

write_file("olds.json", @olds)
write_file("blanks.json", @blanks)
write_file("goodies.json", @goodies)