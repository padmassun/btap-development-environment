# This file will parse output produced by the openstudio server. If osm data is 
# contained in the csv file. It will strip it out into osm files 


require 'zlib'
require 'base64'
require 'csv'
require 'fileutils'


output_folder = './osm_files'
FileUtils::mkdir_p(output_folder)

zip_index = -999
name = -999
csvfile = "DatawithOSM.csv"
open(csvfile) do |csv|
  is_header = true
  csv.each_line do |line|
    values = line.split(",")
    if is_header
      is_header = false
      values.each_with_index do |val,index|
        zip_index = index if val.strip == "btapresults.zipped_model_osm"
        name = index if val.strip == "name" 
      end
      raise ("Could not find name or btapresults.zipped_model_osm column in csv file.") if name < 0 or zip_index < 0
    else
      osm_string = Zlib::Inflate.inflate(Base64.strict_decode64( values[zip_index]) )
      puts "Writing #{values[name]}.osm"
      File.open("#{output_folder}/#{values[name]}.osm", 'w') {|f| f.write(osm_string) }
    end
  end
end

#Strip Zipped data from csv file otherwise it will not open in excel correctly. 
original = CSV.read(csvfile, { headers: true, return_headers: true })
original.delete('btapresults.zipped_model_osm')
CSV.open("#{output_folder}/output.csv", 'w', col_sep: ',') do |csv|
  original.each do |row|
    csv << row
  end
end
