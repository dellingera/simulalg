function nonRepeatRand(min::Number, max::Number, arrayLength::Number)
  #we will make an array with the length of max, then randomly delete numbers
  #from it until it is the proper length

  #"But wait! Thats horribly inefficient except for a very limited use case!"
  #FIXME: Make this actually efficient (Nov 3 2015)

  array = collect(min:max) #get rid of lazy evaluation so deleteat! works

  while(length(array) != arrayLength)
    unitRange = 1:length(array)
    randIndex = rand(1:length(array))
    deleteat!(array, randIndex)
  end

  return array
end

function prettyJson(data)
  log(:blue, "pretty formatting data")
  formattedData = "ERROR IN FORMATTING DATA"
  try
      formattedData = readall(`nodejs lib/makeitpretty.js {{$data}}`)
  catch
      try
          formattedData = readall(`node lib/makeitpretty.js {{$data}}`)
      catch
          log(:magenta, "you need nodejs installed for pretty printing")
          formattedData = data
      end
  end
  log(:green, "finished pretty formatting data")
  return formattedData
end

function writeFile(file::ASCIIString, data::ASCIIString) #helper function for record, makes writing to a file simpler
    log(:blue, "writing data to $file")

    #let's make sure it exists
    run(`touch $file`)

    file = open(file, "w")
    write(file, data)
    log(:green, "finished writing file")
end
