#!/usr/bin/env ruby
$stdin.flush
$stdout.flush
$stdout.sync = true
arguments = ARGV

@path = arguments[0]
@server = arguments[1]
@filtered = []
@raw = []
@cooked = "{"

def scribble(dest, bunch)
  open(Dir.home + "/#{dest}", 'w') do |f|
    f.print bunch
  end
end

def populate()
  e = File.readlines(Dir.home + "/filtered.txt")
  e.each do |line|
    line.chomp!
    @filtered << "#{line}"
  end
end

def cycle()
  @filtered.each do |line|
    ust = %x[wp user meta list "#{line}" --url="#{@server}" --path="#{@path}" --format=csv | grep user-settings-time]
    @user_id = "#{line}"
    if ust.length > 1
      ust.gsub!("\n" , ",")
      keto(ust)
    end
  end
end

def keto(dump)
  collection = dump.split(',')
  collection.each do |line|
    if "#{line}".include? "wp_user"
      line.sub!("wp_user-settings-time", "No blog id")
    else
      line.sub!("wp_", "")
      line.sub!("_user-settings-time", "")
    end
    line.chomp!
    @raw << "#{line}"
  end
end

def cook()
  index = 0
  while index < @raw.length() do
    if "#{@raw[index]}" == "#{@raw[index-3]}"
      @cooked[-2] = ""
      index += 1
      @cooked << '{"blog_id":"' << "#{@raw[index]}"
      index += 1
      @cooked << '","timestamp":"' << "#{@raw[index]}" << '"}],'
      index += 1
    else
      @cooked << '"' << "#{@raw[index]}" << '":['
      index += 1
      @cooked << '{"blog_id":"' << "#{@raw[index]}"
      index += 1
      @cooked << '","timestamp":"' << "#{@raw[index]}" << '"}],'
      index += 1
    end
  end
end

# ust = %x[wp user meta list 1776 --url="#{@server}" --path="#{@path}" --format=csv | grep user-settings-time]
# ust.gsub!("\n" , ",")
# keto(ust)
# @raw.uniq!
# cook()
populate()
cycle()
cook()
@cooked.chop!
@cooked << "}"
# @cooked.gsub!('\],"1776":\[' , ',')
scribble("cooked.json", @cooked)
scribble("fi.txt", @filtered)
scribble("raw.txt", @raw)