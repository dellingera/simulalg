#Simulalg

Simulalg is a framework for testing algorithms for the prediction of stock
algorithms, written in Julia.


##Setup

This will not work in windows. 

You are going to need julia. Apt-get has an out of date version, so:

    sudo add-apt-repository ppa:staticfloat/juliareleases
    sudo add-apt-repository ppa:staticfloat/julia-deps
    sudo apt-get update
    sudo apt-get install julia

For the accurate prediction of stocks, we need a fairly large database. It has
around 6,100 stocks each going back an average of around 4 years. Compressed
it's around 200MB. Not too terrible, but github didn't want to host it. So,
to setup:

    git clone url
    cd dir
    chmod +x setup.sh
    ./setup.sh

Now we need all the dependencies the library needs. Julia has a really
complicated bundling system, so lets just cheat and do it manually.

    julia
    #you are now in a julia shell
    Pkg.add("JSON")
    Pkg.add("SQLite")
    Pkg.add("ArgParse")
    #Ctrl-D to exit

And there you go.


##Testing Algorithms

In the example directory, there are a lot of interesting strategies. Let's just
run all of them for now:

    mv examples algs/examples
    julia start.jl

Of course, most of those need their own packages to be installed. That's okay,
if there is an error they will be skipped.

Providing start.jl with no arguments will quickly test through all algorithms.
To completely test all algorithms:

    julia start.jl -s all

To specify a certain amount of stocks to test each algorithm on

    julia start.jl -s 3000

If you exceed the maximum amount of stocks it will just be reverted to the
actual highest number.

Each stock is yielded more than once. A minimum of 180 days is always yielded,
after that it yields with a certain interval. The default is five days. To
change this:

    julia start.jl -i 1

You can specify a certain location to be tested - either a folder or a file.
Paths are assumed to be inside of the algs/ directory, but you can escape that
with ../.

    julia start.jl -f random #to test all algs in algs/random
    julia start.jl -f random/rand2.jl #to test just the second file
    julia start.jl -f /~/remote/algs/random #some  directory outside of algs


##Making algs

Looking at examples/ should give you a pretty good idea of what the framework
does. Basically:

You make files, each file holds a function called alg

alg is provided with a list of dictionaries sorted by date. Each dictionary
holds:

    "start":  the price at the beginning of the day
    "end":    the price at the end of the day
    "date":   the date of the stock - note that about 1/5 of days are missing
    "high":   the highest price reached by the stock that day
    "low":    the lowest price reached
    "adj":    I don't know, it was included by yahoo finance
    "volume": The volume of the stock that day

Your job is to use that data to predict tomorrows end price. The framework
will take the difference between your prediction and the actual price and add
that to an array. Then it will run statistical analysis of that data.

By default, it will find:

    std, mean, median, range, low, and high.

If you want more analysis, the code lives under lib/scoreHandler.jl.
