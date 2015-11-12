openProcesses = 0
include("lib/logger.jl")
log(:blue, "importing modules")
using SQLite.DB
using JSON
using ArgParse
include("lib/loader.jl") #efficient loading function
include("lib/dataProducers.jl") #reads database and produces data
include("lib/tester.jl") #handles testing of the algorithms
include("lib/scoreHandler.jl") #takes care of scoring algs and records the results
include("lib/helpers.jl") #holds convienence functions
include("lib/converters.jl") #for converting different types
log(:green, "done importing modules")

#we need the database
log(:blue, "importing database")
db = SQLite.DB("lib/data/db.sqlite")
log(:green, "done importing database")

log(:blue, "parsing arguments")
#we need settings for the parser
s = ArgParseSettings("I don't know what this field is for",
                     version = "Version 1.0", # version info
                     add_version = true)      # auto-add version option
#we need to parse out the args
@add_arg_table s begin
    "-f"
        help = "The file the algorithms are in"
    "-l"
        arg_type = Int # only Int arguments allowed
        help = "The minimum value to search"
    "-h"
        arg_type = Int # only Int arguments allowed
        help = "The maximum value to search"
    "-s"
        arg_type = Int
        help = "The amount of segments to split into while searching"
end

#and now we call it...
const args = parse_args(ARGS, s)

const totalStocks = 6117

gloabal variable = 0

#dataproducer is expecting a list to loop over
const list = collect(1:totalStocks)

log(:blue, "starting tuning alg")

tune(parsed_args["f"])
