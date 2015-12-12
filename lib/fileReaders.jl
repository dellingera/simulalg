function loopdown(dir::AbstractString)

    #first, we need a big array of paths to use
    log(:blue, "finding all files to test")
    array = makeArray(dir, String[])
    log(:green, "produced array of testable files")
    #now what that did, is make an array, but all the hand algs are after the
    #pred algs. So that means we can just loop linearly over them, and the
    #cache from the pred will be complete for the hand

    log(:blue, "starting looping over all files")

    #because fast
    multicore_test(array)

    log(:green, "finished looping over all files")
end

function makeArray(dir::AbstractString, array::Array{String,1})
  if isfile(dir)
    push!(array, dir)
  else
      listing = readdir(dir)
      if length(listing) == 0
          log(:yellow, "$dir is empty")
      end
      for path in listing
          array = makeArray(joinpath(dir, path), array)
      end
  end
  return array
end

function multicore_test(array::Array{String,1})
    runningProcesses = []
    while length(array) > 1
        for int in [1:coresToUse;]
            if length(array) > 1
                push!(runningProcesses, @spawn test(pop!(array)))
            end
        end
        #so now we have processes running in the background
        for process in runningProcesses
            fetch(process)
        end
    end
end
