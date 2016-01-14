
const totalStocks = 6117 #the total amount of stocks in the database

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
        help = "The amount of iterations to use"
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
end

#and now we call it...
parsed_args = parse_args(ARGS, s)

const coresToUse = parsed_args["p"]
log(:cyan, "using $coresToUse cores")

const iterNumb = parsed_args["i"]
log(:cyan, "yielding stock data every $iterNumb days")

testNumb = parsed_args["s"]
if testNumb == "all"
    testNumb = totalStocks
    iterNumb = 1
else
    testNumb = makeNumb(testNumb)
    testNumb = testNumb > totalStocks ? totalStocks : testNumb #how many stocks to loop over during testing?
end
log(:cyan, "loading $testNumb stocks per alg")
log(:green, "parsed arguments")

dataLog = Dict() #for storing how well everything did

#we want only a subset of every stock
#but we want every test to use the same subset
const list = nonRepeatRand(0, totalStocks, testNumb)

log(:blue, "starting main loop")

#now start looping over the passed file
loopdown(parsed_args["f"])

#now, we must record the data log
#the data log will print a success message
record(dataLog)

log(:green, "finished testing")

#now we want to make the leaderboard
if testNumb == totalStocks
    makeLeaderBoard("scores/scores.json")
end

log(:white, "the scores are:")
log(:white, readall("lib/scores/scores.json"))
