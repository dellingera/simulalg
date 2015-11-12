function score(data::Array{Float64,1}) #returns an object with stats about the data
    log(:blue, "scoring algorithm")
    data = map(makeNumb, data)
    scoredData = Dict()
    scoredData["mean"] = mean(data)
    scoredData["median"] = median(data)
    scoredData["min"] = minimum(data)
    scoredData["max"] = maximum(data)
    scoredData["StandDev"] = std(data)
    scoredData["range"] = scoredData["max"] - scoredData["min"]
    log(:green, "finished scoring algorithm")
    return scoredData
end

function record(data::Dict) #writes the result of testing to a file, depending on the type of testing
    #we might want some more logic here, whatever
    data = prettyJson(JSON.json(data))
    writeFile("scores/scores.json", data)
end
