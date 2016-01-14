function tune(path::AbstractString, args)
    #first we scan the function to find the actual lowest value
    valueList = Float64[]

    range = args["t"] - args["b"]
    step = range/args["s"]

    for x in args["s"]
        global variable = x * step
        log(:blue, "testing $(args["f"]) when variable = $variable")
        push!(valueList, test(args["f"], true))
        log(:green, "done")
    end

    minId = findMin()

end

function findMin(list::Array{Float64,1})
    listMin = min(list)
    log(:white, "so far the best value is $listMin")
end
