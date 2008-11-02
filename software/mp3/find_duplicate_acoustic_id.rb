require 'rubygems'
require 'find'
require 'id3lib'


def findit(path)
  Find.find(path) do |path|
    next unless FileTest.file?(path)
    next unless path.match(/\.mp3$/)
  
    $stdout.flush

    id3  = ID3Lib::Tag.new(path)
  
    puid = id3.detect  { |frame| frame[:text] if frame[:description]=="MusicIP PUID"  }[:text] rescue nil
  
    unless puid
      puts "NO PUID: #{path}"
      next
    end
  
    if $dup[puid]
      puts "\n\nDUP: \n1:#{path}\n2:#{$dup[puid]}\n\n"
      next
    end
    
    $dup[puid] = path
  end
end

$dup = {}

ARGV.each do |path|
  findit(path)
end

 