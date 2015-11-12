function makeLeaderBoard(filepath::AbstractString)
    #grab the data
    data = JSON.parse(readall(filepath))
    newData = []
    for entry in data
        push!(newData, entry)
    end
    data = newData

    #sort it by lowest std
    data = sort(data, by=stock->(stock[2]["StandDev"]))

    formattedOutput = ""

    #now format that
    for stock in data
        formattedOutput = formattedOutput * "$(stock[1]) - $(stock[2]["StandDev"])\n"
    end

    #now write it

    writeFile("scores/leaderboard.txt", formattedOutput)

end
