cache = Dict()
function effLoad(filePath::AbstractString)
    #okay, so whenever you call a function, julia compiles it then runs it
    #It caches the compiled result, so it's nice and fast
    #The problem is that when I include it every time, it stops being fast
    #So this function will check if the alg is loaded into the cache object
    #and return if it is. Otherwise, it will load it and put it into the
    #cache. And that way every function is only compiled once and this will
    #stop being so slow.

    if !haskey(cache, filePath)
        #so now we wat to load the file and stuff it in here

        #load the file
        log(:blue, "loading $filePath")
        include(filePath)
        log(:green, "loaded $filePath")

        #now stuff the main function into our cache
        cache[filePath] = alg

        #you might be thinking, why keep old algs in RAM? Why not just have a currentAlg variabe?
        #I am planning on getting this to have multithreading in the future. So yeah. Keep the
        #algs loaded.
    end
end
