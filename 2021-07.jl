using StatsBase: countmap

function more_fuel(start, stop) # Part 2
    x = abs(start - stop)
    return Int(x * (x + 1) / 2)
end

function fuel_at(pos, all_pos, crab_counts, part)
    part == 1 && return sum(abs.(all_pos .- pos) .* get.(Ref(crab_counts), all_pos, 0))
    return sum(map(x -> more_fuel(x, pos), all_pos) .* get.(Ref(crab_counts), all_pos, 0))
end

function day7(f, part)
    crabs = open(f) do file
        x = readline(file)
        parse.(Int, split(x, ','))
    end
    n = length(crabs)
    crab_counts = countmap(crabs)
    all_pos = sort(collect(keys(crab_counts)))
    crab_left = cumsum(get.(Ref(crab_counts), all_pos, 0)) # Total number of crabs at and to the left of each position
    
    if part == 1
        # Going from left to right, each increment in position increases fuel by no. of crabs on the left and decreases
        # by number of crabs on the right, resulting in a net change of n_left - (n - n_left) = 2 * n_left - n
        # Fuel required monotonically decreases as long as less than half of crabs are to the left
        min_pos = findfirst(x -> x >= n/2, crab_left) 
        fuel = fuel_at(all_pos[min_pos], all_pos, crab_counts, 1)
    else
        fuels = [fuel_at(p, all_pos, crab_counts, 2) for p in all_pos[1]:all_pos[end]]
        fuel = minimum(fuels)
    end
    return fuel
end