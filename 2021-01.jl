using ShiftedArrays

function incr(A)
    prev = lag(A, default = typemax(Int))
    return sum(A .> prev)
end

function day1(f, roll::Bool)
    depths = parse.(Int, readlines(f))

    !roll && return incr(depths) # Part 1
    
    rolls = (depths .+ lag(depths) .+ lag(depths, 2))[3:end] # Part 2
    return incr(rolls)
end