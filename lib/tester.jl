function test(file::AbstractString)
  log(:blue, "testing prediction alg $file")

  results = Float64[]

  try
    effLoad(file)
  catch e
    log(:magenta, "error in loading $file")
    log(:magenta, e)
    dataLog[file] = "ERROR LOADING FILE"
    return -1
  end

  for data in Task(dataProducer)
    buyNumber = 0
    actualPrice = makeNumb(data[end]["close"])
    projectedPrice = 0 #just making sure this is defined
    pop!(data)

    #load the file and pass the data
    try
        projectedPrice = makeNumb(cache[file](data))
    catch e
        log(:magenta, "error in testing $file")
        log(:magenta, e)
        return -1
    end

    #now we parse the return and score it
    push!(results, projectedPrice - actualPrice)

  end
  dataLog[file] = score(results)

  log(:green, "finished testing pred alg $file")
end
