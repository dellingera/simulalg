function loopdown(dir::AbstractString)

    #first, we need a big array of paths to use
    log(:blue, "finding all files to test")
    array = makeArray(dir, AbstractString[])
    log(:green, "produced array of testable files")
    #now what that did, is make an array, but all the hand algs are after the
    #pred algs. So that means we can just loop linearly over them, and the
    #cache from the pred will be complete for the hand

    log(:blue, "starting looping over all files")

    for alg in array
        test(alg)
    end

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
