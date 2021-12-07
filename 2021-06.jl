using StatsBase: countmap

# Take date of birth of fish and return number of fish spawned from it and its offspring
function fish(dob, t)
    dob > t && return 0
    sum = 0
    x = dob + 9
    while x <= t
        sum += fish(x, t) + 1
        x += 7
    end
    return sum
end

function day6(f, t)
    school = open(f) do file
        l = read(file, String)
        parse.(Int, split(l, ','))
    end
    counts = countmap(school)
    total = sum([i * (fish(day - 8, t) + 1) for (day, i) in counts])
    return total
end
