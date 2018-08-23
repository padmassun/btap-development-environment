require 'json'
require 'csv'

# This piece of code will convert the failed_run_error_log.csv to a json file.
# This is done because Microsoft Excel has a cell character limit and when the
# limit exceeded, excel truncates the data in the cell and the rest of the data
# are displayed in the next couple of lines.
#
# the failed_run_error_log.csv file contains the QAQC errors, Eplus warning and
# fatal errors
log = CSV.open('./failed_run_error_log.csv').readlines
keys = ['Archetype', 'Template', 'City', 'QAQC Fails', 'Eplus fatal Errors', 'Eplus Warnings']

File.open('./failed_run_error_log.json', 'w'){|f|
  data = log.map do |values|
    Hash[keys.zip(values)]
  end
  f.puts JSON.pretty_generate(data)
}


# This piece of code will extract the QAQC failures from the simulations.json file
# and output it as a csv file. The contents of the csv file can be copied to the
# qaqc.template.xlsm file, which parses the qaqc errors and matches it with the
# regex in that file and organizes the qaqc errors based on the category.
results = JSON.parse(File.read('./simulations.json'))

# create a new file and write header
CSV.open("./qaqc.log.csv", 'w') { |f|
  out = %W{bldg_type city json_error}
  f.puts out
}

# iterate through the simulations.json file and record the building_type, qaqc
# errors, and city
results.each { |json|
  CSV.open("./qaqc.log.csv", 'a') { |f|
    bldg_type = json['building_type']
    json_error = json['errors']
    json_error = json_error.join("\n")
    city = json['geography']['city']
    out = %W{#{bldg_type} #{city} #{json_error}}
    f.puts out
  }
}