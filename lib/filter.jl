function filter(today::Float64, tommorrow::Float64)
    #the smallest common stock split is a three for two
    #this results in a theoretical decrease in price of 33.3%
    #however, market noise can increase this difference
    #so, lets filter at, say, 38%?

    percentDifference = (tommorrow - today)/today
    if percentDifference > 38
        return true
    else
        if today < c_minPrice
            return true
        else
            return false
        end
    end
end
