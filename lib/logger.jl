function log(color::Symbol, message::Any)

    if color == :green
        global openProcesses = openProcesses - 1
    end

    indents = ""
    try
        indents = "    " ^ openProcesses
    catch e
        println("$e")
    end

    message = "$indents$message"
    print_with_color(color, message)
    print_with_color(:black, " $(now())")
    println("")


    if color == :blue
        global openProcesses = openProcesses + 1
    end
end
