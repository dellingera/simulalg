const c_totalStocks = 6117 #the total amount of stocks in the database

openProcesses = 0
include("lib/logger.jl")
log(:blue, "importing modules")
using SQLite.DB
using JSON
using ArgParse
include("lib/loader.jl") #efficient loading function
include("lib/fileReaders.jl") #for looping over the files
include("lib/dataProducers.jl") #reads database and produces data
include("lib/tester.jl") #handles testing of the algorithms
include("lib/scoreHandler.jl") #takes care of scoring algs and records the results
include("lib/helpers.jl") #holds convienence functions
include("lib/converters.jl") #for converting different types
include("lib/leaderboard.jl") #for generating the leaderboard
include("lib/filter.jl") #for the removal of penny stocks & splits
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
    "-s"
        nargs = '?'              # '?' means optional argument
        default = 1000              # this is used when the option is not passed
        arg_type = Int # only Int arguments allowed
        constant = 1000             # this is used if --opt1 is paseed with no argument
        help = "The amount of stocks to use"
    "-i"
        nargs = '?'              # '?' means optional argument
        default = 3              # this is used when the option is not passed
        arg_type = Int # only Int arguments allowed
        constant = 3             # this is used if --opt1 is paseed with no argument
        help = "The amount of iterations to use"
    "-f"
        nargs = '?'              # '?' means optional argument
        default = "algs"              # this is used when the option is not passed
        constant = "algs"             # this is used if --opt1 is paseed with no argument
        help = "The file the algorithms are in"
    "-p"
        nargs = '?'
        arg_type = Int
        default = 1
        constant = 1
        help = "The amount of cores to utilize"
    "-d"
        nargs = '?'
        arg_type = Int
        default = 90
        constant = 90
        help = "The amount of days to expose to algorithms"
    "-m"
        nargs = '?'
        arg_type = Float64
        default = 1.0
        constant = 1.0
        help = "The penny stock cut off limit"
end

#and now we call it...
parsed_args = parse_args(ARGS, s)

const c_coresToUse = parsed_args["p"]
log(:cyan, "using $c_coresToUse cores")

const c_daysToYield = parsed_args["d"]
log(:cyan, "giving $c_daysToYield days to every alg")

const c_minPrice = parsed_args["m"]
log(:cyan, "penny stocks are defined at $c_minPrice")



testNumb = parsed_args["s"]
if testNumb == "all"
    testNumb = c_totalStocks
    iterNumb = 1
else
    testNumb = testNumb > c_totalStocks ? c_totalStocks : testNumb
    iterNumb = parsed_args["i"]
end

const c_testNumb = testNumb
const c_iterNumb = iterNumb

log(:cyan, "loading $testNumb stocks per alg")
log(:cyan, "yielding stock data every $c_iterNumb days")
log(:green, "parsed arguments")

dataLog = Dict() #for storing how well everything did

#we want only a subset of every stock
#but we want every test to use the same subset
const c_list = nonRepeatRand(0, c_totalStocks, c_testNumb)

log(:blue, "starting main loop")

#now start looping over the passed file
loopdown(parsed_args["f"])

#now, we must record the data log
#the data log will print a success message
record(dataLog)

log(:green, "finished testing")


println()
log(:white, "process complete")
