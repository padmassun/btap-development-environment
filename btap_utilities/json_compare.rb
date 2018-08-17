require 'json'

def compare_array_with_array(new, old)
  if (old - new).empty?
    puts "NEW: Does not have #{old - new}"
  end
  if (new - old).empty? 
    puts "OLD: Does not have #{new - old}"
  end
  sleep(5)
end

def compare_array_of_hash(new, old, ignore_keys, message)
  new.each { |new_hash|
    if new_hash.key? "name"
      old.each { |old_hash|
        next if old_hash["name"] != new_hash["name"]
        iterate(new_hash,old_hash,ignore_keys,message)
      }
    end
  }
  
end


def iterate(new,old,ignore_keys,message = nil)
  tollerance = true
  if new.is_a?(Array)
    if(new[0].is_a?(Hash))
      compare_array_of_hash(new, old,ignore_keys, message)
      #sleep(5)
    elsif (new[0].is_a?(Array))
      compare_array_with_array(new, old)
      #sleep(5)
    end
    #############################
    ####### END OF ARRAY ########
    #############################
  elsif new.is_a?(Hash)
    new.each do |k, v| 
      unless ignore_keys.include? k
        if v.is_a?(Hash) || v.is_a?(Array)
          iterate(new[k],old[k],ignore_keys,"#{message}.#{k}")
        else
          if new.nil?
            puts "no new[k]"
          elsif old.nil?
            puts "no old[k]"
          else
            if(new[k] != old[k])
              if tollerance
                if new[k].is_a?(Float)
                  percent_diff = 1
                  diff = (new[k] - old[k])/new[k]*100
                  if  diff > percent_diff
                    puts "#{message}.#{k}\nH-NEW: #{new[k]}\n"
                    puts "H-OLD:#{old[k]}\n==============="
                  end
                end
              else
                puts "#{message}.#{k}\nH-NEW: #{new[k]}\n"
                puts "H-OLD:#{old[k]}\n==============="
              end
            end
          end
        end
      end
    end
  else
    puts "THE NED #{new}"
  end

end

ignore_keys = ["constructions","eplusout_err", "ruby_warnings", "information", "warnings", "errors", "unique_errors", "sanity_check"]
puts "Hello World"
json_20 = JSON.parse(File.read("./post2/RESULTS-04-04-2017.json"))
json_14 = JSON.parse(File.read("./pre2/RESULTS-03-29-2017.json"))

#os_std = JSON.parse(File.read("./post2/RESULTS-04-04-2017.json"))
#btap = JSON.parse(File.read("./pre2/qaqc.json"))

#iterate(os_std,btap,ignore_keys)
#string = "NECB 2011-FullServiceRestaurant-NECB HDD Method-CAN_BC_Prince.George.718960_CWEC.epw created: 2017-04-03 19:12:33 +0000"
#puts string.split('-')

count = 0
json_20.each do |new|
  new_bldg = new["building"]["name"].split('-')[1]
  new_epw = "#{new['geography']['state_province_region']}_#{new['geography']['city']}"
  json_14.each do |old|
    old_bldg = old["building"]["name"].split('-')[1]
    old_epw = "#{old['geography']['state_province_region']}_#{old['geography']['city']}"
    if (new_bldg == old_bldg) and (new_epw == old_epw)
      puts "================#{new_bldg}   #{new_epw}================"
      iterate(new,old,ignore_keys)
      count +=1
    end
  end
end

#count = 0
#json_20.each do |new|
#  new_bldg = new["building_type"]
#  new_epw = "#{new['geography']['state_province_region']}_#{new['geography']['city']}"
#  json_14.each do |old|
#    old_bldg = old["building_type"]
#    old_epw = "#{old['geography']['state_province_region']}_#{old['geography']['city']}"
#    if (new_bldg == old_bldg) and (new_epw == old_epw)
#      puts "================#{new_bldg}   #{new_epw}================"
#      iterate(new,old,ignore_keys)
#      count +=1
#    end
#  end
#end