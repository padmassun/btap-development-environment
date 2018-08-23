require 'json'
require 'json-compare'
require 'bigdecimal'

# old json file
json_243 = JSON.parse(File.read("./243simulations_2011.json"))

# new json file
json_260 = JSON.parse(File.read("./260simulations_2011.json"))

# keys to exclude
# not including the key called 'name' because it is used for a lot of other things. 
# But the building name will be ignored. It has been harcoded
exclude = ['run_uuid', 'analysis_id', 'openstudio_version', 'date', 'analysis_name', 'note']

class String
  def is_num?
    true if Float(self) rescue false
  end
end

def compare_numeric(new_value, old_value, tol = 5, message = '', output = [])
  # Use BigDecimal to round the numeric value to the specified tolerance and check if the old_diff's value is the 
  # same as the new_diff's value
  if !((BigDecimal.new(new_value) - BigDecimal.new(old_value)).abs < BigDecimal.new("1e-#{tol}"))
    # if the values do not match try changing the tolerance
    
    # https://ruby-doc.org/stdlib-2.1.1/libdoc/bigdecimal/rdoc/BigDecimal.html#method-i-split
    sign, significant_digits, base, exponent = BigDecimal.new(new_value).split
    sign_o, significant_digits_o, base_o, exponent_o = BigDecimal.new(old_value).split
    
    # get the maximum decimal places (of new_value and old_value) and subtract 1. This would be the new tolerance if it is less than the specified default tolerance
    new_tol = [significant_digits.to_s.length - exponent, significant_digits_o.to_s.length - exponent_o].max - 1
    if (new_tol) < tol # check if the new tolerance is less than the default specified tolerance
      
      # if there is still a difference after reducing the tolerance, report it
      if !((BigDecimal.new(new_value) - BigDecimal.new(old_value)).abs < BigDecimal.new("1e-#{new_tol}"))
        out = {}
        out['message'] = "[#{new_tol}] Key:#{message}\nnew_value:\n#{new_value}\nold_value:\n#{old_value}\n".gsub("['update']", '').gsub('update', '')
        out['percent_diff_1'] = ((new_value.to_f - old_value.to_f)/old_value.to_f).abs * 100.0
        out['percent_diff_2'] = ((new_value.to_f - old_value.to_f)/new_value.to_f).abs * 100.0
        out['percent_diff'] = [out['percent_diff_1'], out['percent_diff_2']].max
        out['key'] = message
        out['new_value'] = new_value
        out['old_value'] = old_value
        output <<  out
        message = ''
      end
    else # else if the new tolerance is more than the default specified tolerance, use the default tolerance
      out = {}
      out['message'] = "[#{tol}] Key:#{message}\nnew_value:\n#{new_value}\nold_value:\n#{old_value}\n".gsub("['update']", '').gsub('update', '')
      out['percent_diff_1'] = ((new_value.to_f - old_value.to_f)/old_value.to_f).abs * 100.0
      out['percent_diff_2'] = ((new_value.to_f - old_value.to_f)/new_value.to_f).abs * 100.0
      out['percent_diff'] = [out['percent_diff_1'], out['percent_diff_2']].max
      out['key'] = message
      out['new_value'] = new_value
      out['old_value'] = old_value
      output << out
      message = ''
    end
  end
end

def compare_with_decimal_places(new_value, old_value, tol = 5, message = '', output = [])
  # as long the input parameter new_value is a hash, iterate through the hash recursively until it is not a hash
  if (new_value.is_a? Hash) # The json-compare gem will only have hashes
    new_value.each do |key, value| # iterate through each of the 
      new = new_value[key] # store the value
      old = old_value[key] # store the value
      message.gsub!("['update']", '')
      message.gsub!('update', '')
      if message == ''
        message = "['#{key}']" # store the key as part of the message
      else
        message = "#{message}['#{key}']" # store the key as part of the message
      end
      compare_with_decimal_places(new, old, tol, message, output) # recursive as long as value is a Hash
      message.gsub!(/(.+)(\[.+\])$/, '\1') # get rid of the last key added as part of the message
    end
  else
    # At here, the values passed as a parameter is not a hash, so It can be a string or a number
    if new_value.is_num?
      compare_numeric(new_value, old_value, tol , message , output)
    else # if the new_value is a string
      if message.gsub("['update']", '').gsub('update', '') != "['building']['name']" # skip building name
        if new_value.strip != old_value.strip
          out = {}
          out['message'] = "Key:#{message}\nnew_value:\n#{new_value}\nold_value:\n#{old_value}\n".gsub("['update']", '').gsub('update', '')
          out['percent_diff'] = 0
          out['key'] = message
          out['new_value'] = new_value
          out['old_value'] = old_value
          output << out
          message = ''
        end
      end
    end
  end
  return output
end

# create an empty diff.txt file
File.open('diff.txt', 'w'){ |f|
	f.puts ""
}

diff_260 = []
diff_243 = []

percent_diff = []

# compare the content of the json files if and only if the content of the json file that has the same building name and city
json_260.each do |new| # iterate through the contents of the new json file
  new_bldg = new["building"]["name"].split('-')[1]
  new_epw = "#{new['geography']['state_province_region']}_#{new['geography']['city']}"
  json_243.each do |old| # iterate through the contents of the old json file
    old_bldg = old["building"]["name"].split('-')[1]
    old_epw = "#{old['geography']['state_province_region']}_#{old['geography']['city']}"
    if (new_bldg == old_bldg) and (new_epw == old_epw) # match the building name and the city
      # puts "================#{new_bldg}   #{new_epw}================"
      new_diff = JsonCompare.get_diff(old, new, exclude) # marks the changes in the new_json
      old_diff = JsonCompare.get_diff(new, old, exclude) # marks the changes in the old_json
      diff_260 << new_diff
      diff_243 << old_diff
      # compare the diff of the changes identified by the JsonCompare gem
      output =  compare_with_decimal_places(new_diff, old_diff, 5)
      # if changes were found report it. This condition is checked because the building name is ignored.
      if !output.empty?
        File.open('diff.txt', 'a'){ |f|
          f.puts "Building: #{new_bldg}" # Report building name
          f.puts "City: #{new_epw}" # Report weather files
          f.puts "Diff: [tolerance] message" # general message regarding the format of the output
          output.each_with_index do |value, index|
            f.puts output[index]['message'] # report diff message
            f.puts "Maximum percent difference:" # report maximum percent difference
            f.puts output[index]['percent_diff']
            f.puts "\n"
            out = {}
            percent_diff << out
            out['Building'] = new_bldg
            out['City'] = new_epw
            out['diff_data'] = output[index]
          end
          f.puts "_"*40 + "\n"
        }
      end
    end
  end
end

# puts JSON.pretty_generate(diff_260.last)

# write the content generated by JsonCompare gem
File.open('./diff_260.json', 'w'){ |f|
	f.puts JSON.pretty_generate(diff_260)
}
File.open('./diff_243.json', 'w'){ |f|
	f.puts JSON.pretty_generate(diff_243)
}
File.open('./diff_percent.json', 'w'){ |f|
  percent_diff = percent_diff.sort_by {|value| value['diff_data']['percent_diff']}
  percent_diff = percent_diff.reverse
  f.puts JSON.pretty_generate(percent_diff)
}
