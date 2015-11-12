function makeString(item::Any)
    return "$item"
end

function makeNumb(item::Number)
  return item
end
function makeNumb(item::AbstractString)
  return parse(Float64, item)
end
