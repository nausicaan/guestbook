#!/usr/bin/env ruby
$stdin.flush
$stdout.flush
$stdout.sync = true
arguments = ARGV

@path, @server = arguments[0], arguments[1]
@filtered, @nickname, @raw = [], [], []
@duds, @cooked  = "{", "{"

def scribble(dest, bunch)
  open(Dir.home + "/#{dest}", 'w') do |f|
    f.print bunch
  end
end

def populate()
  e = File.readlines(Dir.home + "/ordered.txt")
  e.each do |line|
    line.chomp!
    @filtered << "#{line}"
  end
end

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
      @duds << '{"ID":"' << "#{line}" << '","Username":"' << "#{nn}" << '"},'
    end
  end
end

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
@cooked.chop!
@duds << "}"
@cooked << "}"
scribble("duds.json", @duds)
scribble("cooked.json", @cooked)