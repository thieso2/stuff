require 'fileutils'

# unzip /Volumes/XML/aubi_motorboerse_20080924.zip
# ruby /Volumes/XML/shorten_image_file_names.rb
# zip -r /Volumes/XML/aubi_motorboerse_20080924-fixed gruppe*

def doit(xml_file,img_dir)
  unless File.exist?(xml_file) && File.directory?(img_dir)
    puts "!!! #{xml_file} #{img_dir}"
    return
  end

  newfile = ""
  img_idx = 0;

  group = xml_file.match(/\d+/)[0] rescue 0
  
  ts = Time.now.strftime("%d%H%M")

  my_pictures = []


  IO.readlines(xml_file).each do |line|
    if line =~ /<PBOX image="([0-9a-z-]+.jpg)">/i

      orig_name = $1
      new_name = ts + "-" + group + "-%04d.jpg" % img_idx
      img_idx += 1

      File.rename("#{img_dir}/#{orig_name}","#{img_dir}/#{new_name}")
    
      my_pictures << new_name
      
      newfile << line.gsub($1, new_name)
    else
      newfile << line
    end
  end
  
  FileUtils.cd(img_dir) do |dir|
    unreferenced = Dir["*"] - my_pictures
    
    if unreferenced.any?
      puts "unreferenced: #{unreferenced.inspect}"
      FileUtils.remove(unreferenced) 
    end
  end

  File.open(xml_file,"w") { |f| f.write newfile }
end

Dir["gruppe?"].each do |gruppe|
  puts "-- #{gruppe}"
  doit("#{gruppe}/DocGenSources/#{gruppe}.xml", "#{gruppe}/DocGenPictures")
end
