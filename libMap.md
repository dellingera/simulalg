#Map of Library

##Step 1: Determine what is being tested

To test a specific algorithm:

`start pred/anthony/fract/iter1.jl`

To test all algorithms in a file:

`start hand/anthony/cons`

To specify the amount of repetitions to test with:

`start hand/anthony/cons 2000`

This means that 2000 stocks will be looped over

To use all the stocks:

`start pred/anthony/fract all`

##Step 2: Loop over what is being tested:

  call loopdown on the path being tested
    is it a pred file?
      call test on it
    is it a hand file?
      jump to step A
    is it a directory?
      call loopdown on it

##Step 3: Load the algorithm

  call effLoad on the algorithm
    this loads the file into the function cache

##Step 4: Start a Task over a stock data producing Task

  How many stocks am I testing?
    all
      loop over all of them
    a fixed amount
      is it less than all of them?
        yes
          randomly select
        no
          well, loop over all of them

##Step 5: Make that Task return data in increments

  What day increment are we using? 5?
    Return the stock data numerous times, 5 larger every time, 6 month min

##Step 6: Call the pred alg for every set of data returned

  Call it from the cache
  add it to the result store

##Step 7: Score the pred alg

  now make statistical data from the result store
  add that to the alg performance store

##Step 8: record the scores in a file

  Good enough for now lol
