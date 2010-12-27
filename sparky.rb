#!/usr/bin/ruby

#######################################
# Auth : Simon (psyomn) Symeonidis
# 
# I'm not the best coder out there :)
#
# This started as a personal app, and
# Hopefully with time, it will be 
# used by different people. 
#######################################
# TODO
#  o Need to add a scroll for when
#    there are too many items in the
#    listbox
#
#  o Find a way on how to make the 
#    window part of the desktop like
#    conky or gdeskcal
#######################################

require 'tk'
require 'fileutils'

#######################################
# Load Settings / Saved data
#######################################

base = "#{ENV['HOME']}/.config/sparky" # The base
conf = "#{base}/sparky.conf"           # Possible configuration file
save = "#{base}/sparkysave.dat"        # Save the tasks in this file
$arr = Array.new                       # Store the loaded data
storeData = Array.new

if File.file? conf and File.file? save # both exist save data
  puts "Loading data"
  s = File.open(save)
  $arr = s.readlines

  $arr.each_index { |x| $arr[x] = $arr[x].gsub(/\n/, '') }

  p $arr if ARGV[0] == 'd'

else # create folders, create files
  puts "Creating Folders and Files"
  FileUtils.mkdir_p(base) # create the dirs recursively
  FileUtils.touch(conf)   # create the configuration save file
  FileUtils.touch(save)   # create the save file
end

#######################################
# Main program
#######################################

todoList  = TkListbox.new do
  ## Initialize with saved data
  $arr.each_index { |x|
    insert 0, $arr[x]
    storeData[x] = $arr[x]
  }
  ## End init

  selectmode "multiple"
  width 20
  height 10
end

taskenter = TkEntry.new do
  bind("Return") { 
    taskenter.value = taskenter.value.strip
    if value != "" 
       todoList.insert 0, taskenter.value
       taskenter.value = ""
       
       ## Update the list to save at end
       todoList.size.times { |x|
       storeData[x] = todoList.get(x)
    }
    end 
  }
end

doneButton= TkButton.new do
  text "Done"
  command proc {
    todoList.curselection.each_index{ |li|
      todoList.delete(todoList.curselection[li-li])
    }
    
    ## Update the list to save at end
    todoList.size.times { |x|
      storeData[x] = todoList.get(x)
    }
  }
end

taskenter.grid('row'=>'0', 'column'=>'0')
todoList.grid('row'=>'1', 'column'=>'0')
doneButton.grid('row'=>'2', 'column'=>'0')

Tk.mainloop

############################################
# Save the changes
############################################

puts "The data to store is : "
puts storeData

saveFile = File.open(save, "w")
storeData.each_index { |x|
  saveFile.write(storeData[x])
  saveFile.write("\n")
}
