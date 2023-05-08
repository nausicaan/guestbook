#!/usr/bin/env ruby
$stdin.flush
$stdout.flush
$stdout.sync = true
arguments = ARGV

@path, @server = arguments[0], arguments[1]
@filtered, @nickname, @raw = [], [], []
@duds, @cooked  = "[", "{"

# Write a passed variable to a named file
def scribble(dest, bunch)
  open(Dir.home + "/#{dest}", 'w') do |f|
    f.print bunch
  end
end

# Read ordered.txt and transfer the contents to @filtered
def populate()
  e = File.readlines(Dir.home + "/filtered.txt")
  e.each do |line|
    line.chomp!
    @filtered << "#{line}"
  end
end

# Grep the list of users with site specific login information, and direct those without to @duds
def cycle()
  @filtered.each do |line|
    nn = %x[wp user meta get "#{line}" nickname --url="#{@server}" --path="#{@path}"]
    nn.chomp!
    ust = %x[wp user meta list "#{line}" --url="#{@server}" --path="#{@path}" --format=csv | grep user-settings-time]
    if ust.length > 1
      @nickname << nn
      ust.gsub!("\n" , ",")
      keto(ust)
    else
      @duds << '{"ID":' << "#{line}" << ',"Username":"' << "#{nn}" << '"},'
    end
  end
end

# Filter out extraneous information to extract the blod_id
def keto(dump)
  collection = dump.split(',')
  collection.each do |line|
    if "#{line}".include? "wp_user"
      line.sub!("wp_user-settings-time", "0")
    else
      line.sub!("wp_", "")
      line.sub!("_user-settings-time", "")
    end
    line.chomp!
    @raw << "#{line}"
  end
end

# Create the cooked.json file
def cook()
  index, nindex = 0, 0
  while index < @raw.length() do
    if "#{@raw[index]}" == "#{@raw[index-3]}"
      @cooked[-2] = ""
      index += 1
      @cooked << '{"blog_id": ' << "#{@raw[index]}"
      index += 1
      @cooked << ',"timestamp": ' << "#{@raw[index]}" << '}],'
      index += 1
    else
      @cooked << '"' << "#{@nickname[nindex]}" << '":['
      nindex += 1
      @cooked << '{"ID": ' << "#{@raw[index]}" << '},'
      index += 1
      @cooked << '{"blog_id": ' << "#{@raw[index]}"
      index += 1
      @cooked << ',"timestamp": ' << "#{@raw[index]}" << '}],'
      index += 1
    end
  end
end

populate()
cycle()
cook()
@duds.chop!
@cooked.chop!
@duds << "]"
@cooked << "}"
scribble("duds.json", @duds)
scribble("cooked.json", @cooked)