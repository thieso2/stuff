lines=<<EOT.split("\n")
1225545640.155 0.004 200 0.004 "GET /automarkt_5842.html?categoryAlias=vehicles_cars&MANUFACTURER=BMW&MODEL=X5&attributes(FUEL_TYPE_AAZ)=Gas&attributes(TRANSMISSION_TYPE_AAZ)=&attributes(MILEAGE_FROM)=&attributes(MILEAGE_TO)=&attributes(KW_FROM)=222&attributes(KW_TO)=&attributes(FIRST_REGISTRATION_YEAR_FROM)=&attributes(FIRST_REGISTRATION_YEAR_TO)=&priceFloor=&priceCeiling=30000&POSTAL_CODE=&DISTANCE=&attributes(CAR_FEATURES_INTERIOR)=routeGuidanceSystem&ADVANCED=true HTTP/1.1" 20 80.187.96.25
1225545640.489 0.000 200 0.000 "GET /automarkt_5842.html?categoryAlias=vehicles_cars&MANUFACTURER=Opel&MODEL=Vectra&attributes(FUEL_TYPE_AAZ)=any&attributes(TRANSMISSION_TYPE_AAZ)=&attributes(MILEAGE_FROM)=&attributes(MILEAGE_TO)=&attributes(KW_FROM)=&attributes(KW_TO)=110&attributes(FIRST_REGISTRATION_YEAR_FROM)=1990&attributes(FIRST_REGISTRATION_YEAR_TO)=&priceFloor=&priceCeiling=2000&POSTAL_CODE=35066&DISTANCE=200&ADVANCED=true HTTP/1.1" 20 83.181.68.181
1225545640.655 0.001 200 0.001 "GET /automarkt_5842.html?categoryAlias=vehicles_cars&MANUFACTURER=Skoda&MODEL=Octavia&attributes(FUEL_TYPE_AAZ)=Diesel&attributes(TRANSMISSION_TYPE_AAZ)=&attributes(MILEAGE_FROM)=&attributes(MILEAGE_TO)=&attributes(KW_FROM)=81&attributes(KW_TO)=&attributes(FIRST_REGISTRATION_YEAR_FROM)=2000&attributes(FIRST_REGISTRATION_YEAR_TO)=&priceFloor=&priceCeiling=6000&POSTAL_CODE=33689&DISTANCE=200&ADVANCED=true HTTP/1.1" 5 92.196.38.153
1225545640.728 0.001 200 0.001 "GET /automarkt_5842.html?categoryAlias=vehicles_cars&MANUFACTURER=Opel&MODEL=&attributes(FUEL_TYPE_AAZ)=any&attributes(TRANSMISSION_TYPE_AAZ)=&attributes(MILEAGE_FROM)=&attributes(MILEAGE_TO)=&attributes(KW_FROM)=&attributes(KW_TO)=&attributes(FIRST_REGISTRATION_YEAR_FROM)=2000&attributes(FIRST_REGISTRATION_YEAR_TO)=&priceFloor=&priceCeiling=2500&POSTAL_CODE=66740&DISTANCE=200&ADVANCED=true HTTP/1.1" 5 84.165.91.23
1225545641.527 0.001 200 0.001 "GET /automarkt_5842.html?categoryAlias=vehicles_cars&MANUFACTURER=Mercedes-Benz&MODEL=E+500&attributes(FUEL_TYPE_AAZ)=any&attributes(TRANSMISSION_TYPE_AAZ)=&attributes(MILEAGE_FROM)=0&attributes(MILEAGE_TO)=100000&attributes(KW_FROM)=&attributes(KW_TO)=&attributes(FIRST_REGISTRATION_YEAR_FROM)=1991&attributes(FIRST_REGISTRATION_YEAR_TO)=1995&priceFloor=&priceCeiling=&POSTAL_CODE=&DISTANCE=&ADVANCED=true HTTP/1.1" 5 91.9.158.198
1225557353.401 1.848 200 1.548 "GET /googlesearch/suche.php?q=volvo+c+30&w=3 HTTP/1.1" 13469 79.232.230.120
1225557354.667 0.565 200 0.565 "GET /artikel/ratgeber-technik_458580.html HTTP/1.1" 15258 87.163.156.208
1225557357.010 0.039 200 0.038 "GET /artikel/einparkhilfen-zum-nachruesten_43903.html HTTP/1.1" 14025 88.73.81.176
1225557357.017 0.039 200 0.038 "GET /artikel/miss-tuning-kalender-2009_798353.html HTTP/1.1" 14368 79.215.253.251
1225494971.036 0.000 200 - "GET /img/iconlib_arrows_browse.gif HTTP/1.1" 410 41.248.160.164
EOT



$requests = {}

def count_request(path, time)
  that = $requests[path] ||= [0,0.0]
  
  that[0] += 1
  that[1] += time
end

def parse(line)
  _, msec, request_time, status, upstream_response_time, request, body_bytes_sent, remote_addr =  line.match(/([\d\.]+) ([\d\.]+) (\d+) ([\d\.-]+) \"(.+?)\" (\d+) ([\d\.]+)/).to_a
  
  return if upstream_response_time == '-'
  
  php_time = upstream_response_time.to_f
  
  method, path = request.split(/[\? ]/)

  count_request(path, php_time)
end

lines.each do |line|
  begin
    parse(line)
  rescue Exception => e
    puts e.inspect
    puts line
  end
end

$requests.sort { |a,b| a[1][1] <=> b[1][1] }.reverse.each do |path, info| 
  puts "#{"%4d" % info[0]} #{"%6.2f" % info[1]} #{path}"
end
