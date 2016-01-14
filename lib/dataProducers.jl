function dataProducer(stockIds)
    producer = @task stockProducer(stockIds)
    for stock in producer
        stockLength = length(stock)
        if stockLength > 180
            visibleData = []
            for a in 1:180
                push!(visibleData, format(stock[1]))
                shift!(stock)
            end

            ticker = 0
            for day in stock
                push!(visibleData, format(day))
                ticker = ticker + 1
                if ticker == iterNumb
                    ticker = 0
                    produce(visibleData)
                end
            end
        end

    end
end

function stockProducer(stockIds)

  #now loop over that list
  for id in list
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
