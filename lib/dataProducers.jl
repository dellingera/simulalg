function dataProducer(stockIds)
    producer = @task stockProducer(stockIds)
    for stock in producer
        #stock is a list of csv's

        #lets see if this stock is enough data
        stockLength = length(stock)
        if stockLength > c_daysToYield

            #I don't like csv. Let's make it a list of dictionaries
            stock = map(format, stock)

            #we can yield this one stock numerous times. This is what we are
            #currently yielding:
            visibleData = Dict{Any,Any}[]

            #let's shift the days from stock into yeilded stock, until
            #it is long enough to pass
            for a in 1:c_daysToYield
                push!(visibleData, stock[1])
                shift!(stock)
            end

            #we don't yeild every day, sometimes we wait. We need to keep track
            #of when we last yielded
            ticker = 0

            #this is for the handling of splits
            timeout = -1

            #now we just loop until it's all used
            for day in stock

                #if the new data isn't good, skip until it's gone
                if(filter(visibleData[end]["close"], day["close"]))
                    timeout = c_daysToYield
                end
                timeout = timeout - 1

                push!(visibleData, day)
                ticker = ticker + 1
                if ticker == c_iterNumb
                    ticker = 0
                    if timeout < 0
                        produce(visibleData)
                    end
                end
            end
        end

    end
end

function stockProducer(stockIds)

  #now loop over that list
  for id in c_list
    try
      data = SQLite.query(db, "SELECT data FROM stocks WHERE id = $id")
      #that's some weird result set
      data = data.data[1][1]
      #that's some weird nullable value thing, because obviously having nulls is
      #a great language feature we must use a library to implement
      data = data.value
      #now, it's a normal string. Let's make it a list of lists
      data = map(function (line::AbstractString) return split(line, ",") end, split(data, r"\n"))

      #now, for some reason, the first item is blank.
      shift!(data)

      #wew yeah I really want an ORM. Anyway:
      produce(data)
    catch e
        #the stock is corrupted, just skip it
    end
  end
end

function format(list)
    #we want this raw list of strings to be a dictionary of parsed data
    dict = Dict()
    dict["date"] = list[2]
    dict["open"] = makeNumb(list[3])
    dict["high"] = makeNumb(list[4])
    dict["low"] = makeNumb(list[5])
    dict["close"] = makeNumb(list[6])
    dict["volume"] = makeNumb(list[7])
    dict["adj"] = makeNumb(list[8])

    return dict
end
