function find_cost(A) # Dijkstra
    costs = fill(999999999, size(A))
    visited = ones(Int, size(A))
    i, j = 1, 1
    costs[i, j] = 1 # offset to avoid zero multiplication
    while true
        visited[i, j] = 10000000000
        for (m, n) in neighbours(A, i, j)
            visited[m, n] == 1 && (costs[m, n] = min(costs[m, n], costs[i, j] + A[m, n]))
        end
        i, j = Tuple(findmin(costs .* visited)[2])
        (i, j) == size(A) && break
    end
    return costs[size(A)...] - 1
end

neighbours(A, i, j) = filter!(((x, y),) -> x ∈ 1:size(A, 1) && y ∈ 1:size(A, 2), [(i-1, j), (i+1, j), (i, j-1), (i, j+1)])

function expand(A)
    row = hcat([A .+ i for i in 0:4]...)
    return mod1.([row; row .+ 1; row .+ 2; row .+ 3; row .+ 4], 9)
end

function day15(f, part)
    riskmap = open(f) do file
        transpose(reduce(hcat, [collect(x) .- '0' for x in eachline(file)]))
    end
    part > 1 && (riskmap = expand(riskmap)) # part 2
    
    return find_cost(riskmap)
end