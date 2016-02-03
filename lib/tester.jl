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

  #now we want to split the list constant, containing the stocks to be used in
  #looping, into smaller loops for every core to loop over
  lists = splitListByCores()
  runningProcesses = []

  for list in lists
      push!(runningProcesses, [file, @spawn testPiece(list, file)])
  end
  log(:blue, "collecting processes")
  for process in runningProcesses
      currentResults = fetch(process[2])
      if(typeof(currentResults) == Int64)
          log(:magenta, "error in testing $(process[1]). The error is:")
          log(:magenta, "$(process[2])")
      elseif typeof(currentResults) == RemoteException
          log(:magenta, currentResults)
      else
          append!(results, currentResults)
      end
      gc()
  end
  log(:green, "done collecting processes")

  log(:green, "finished testing pred alg $file")

  log(:blue, "recording results")
  scores = score(results)
  dataLog[file] = scores
  log(:green, "done")
end

function testPiece(StockIds, file)
    results = Float64[]
    producer = @task dataProducer(StockIds)
    for data in producer
        buyNumber = 0
        actualPrice = makeNumb(data[end]["close"])
        projectedPrice = 0 #just making sure this is defined
        pop!(data)

        #load the file and pass the data
        try
            fileResult = cache[file](data)
            projectedPrice = makeNumb(fileResult)
        catch e
            log(:magenta, "error in testing $file")
            log(:magenta, e)
            return -1
        end

        #now we parse the return and score it
        push!(results, Float64(projectedPrice - actualPrice))
    end
    return results
end

function splitListByCores()
    log(:blue, "splitting big list of stocks into little lists")
    #so coresToUse is the amount of cores
    #and list is the amount of lists
    lengthOfIds = length(c_list)
    segment = floor(lengthOfIds/c_coresToUse)

    splitUp = []

    for x in [1:c_coresToUse;]
        startValue = convert(Int, segment*x-segment+1)
        endValue = convert(Int, segment*x)
        push!(splitUp, c_list[startValue:endValue])
    end
    log(:green, "done splitting things")
    return splitUp
end
