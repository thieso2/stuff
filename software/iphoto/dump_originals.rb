require 'rubygems'
require 'plist'
require 'iphoto2-thies'

iphoto = IPhoto2.new(ARGV[0] || "/Data/iPhoto Library/AlbumData.xml")
iphoto.albums.each do |album|
  album.each do |image|
    puts "#{album.name} #{image.media_type} #{image.image_type} #{"%010d" % (File.size(image.path) rescue "-1")}"
  end
end
