function log(color::Symbol, message::Any)

    message = trim("$message")

    if color == :green
        global openProcesses = openProcesses - 1
    end

    indents = ""
    try
        indents = "    " ^ openProcesses
    catch e
        println("$e")
    end

    message = indents * message
    print_with_color(color, message)
    print_with_color(:black, " $(now())")
    println("")


    if color == :blue
        global openProcesses = openProcesses + 1
    end
end

function trim(message::AbstractString)
    if length(message) > 500
        return message[1:250] * " . . . " * message[end-250:end]
    else
        return message
    end
end
