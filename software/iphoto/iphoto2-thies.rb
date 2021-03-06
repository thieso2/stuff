require 'plist'

class IPhoto2
  def initialize( filename="#{ENV['HOME']}/Pictures/iPhoto Library/AlbumData.xml" )
    @plist = Plist.parse_xml( filename )
    @images = Hash.new
  end

  def library
    @library ||= Album.new( @plist["List of Albums"].find() do |a|
                              a["Master"]
                            end, self )
  end

  def last_roll
    @last_roll ||= Album.new( @plist["List of Albums"].find() do |a|
                                a["AlbumName"] == "Last Roll"
                              end, self )
  end

  def last_month
    @last_month ||= Album.new( @plist["List of Albums"].find() do |a|
                                 a["AlbumName"] == "Last 12 Months"
                               end, self )
  end

  def rolls
    @rolls ||= @plist["List of Rolls"].collect do |roll|
      Album.new(roll, self)
    end
  end

  def albums
    @albums ||= @plist["List of Albums"].find_all() do |a|
                  a["Album Type"] == "Regular"
                end.collect do |a|
                  Album.new( a, self )
                end
  end

  def get_image( image_id )
    @images[image_id] ||= Image.new(@plist["Master Image List"][image_id.to_s], self)
  end

  def path
    @plist["Archive Path"]
  end

end

class Album
  attr_accessor :plist
  include Enumerable

  def initialize( plist, iphoto )
    @plist = plist
    @iphoto = iphoto
  end

  def album_id
    @plist["AlbumId"]
  end

  def name
    @plist["AlbumName"]
  end

  def images
    @images ||= @plist["KeyList"].collect do |image_id|
      @iphoto.get_image(image_id)
    end
  end

  def [] key
    images[key]
  end

  def size
    images.size
  end

  def each
    images.each do |i|
      yield i
    end
  end

end

class Image
  attr_accessor :plist
  def initialize( plist, iphoto )
    @plist = plist
    @iphoto = iphoto
  end

  def path
    @plist["ImagePath"]
  end

  def thumb
    @plist["ThumbPath"]
  end

  def caption
    @plist["Caption"]
  end

  def comment
    @plist["Comment"]
  end

  def image_type
    @plist["ImageType"]
  end

  def media_type
    @plist["MediaType"]
  end

  def guid
    @plist["GUID"]
  end

  def date
    @date ||= Time.at( Time.mktime( 2001, 1, 1 ).to_i + @plist["DateAsTimerInterval"].to_i )
  end
end
