using ImageMorphology

function min_neighbour(A, ci)
    i, j = Tuple(ci)
    u = i == 1 ? 10 : A[i-1, j]
    d = i == size(A)[1] ? 10 : A[i+1, j]
    l = j == 1 ? 10 : A[i, j-1]
    r = j == size(A)[2] ? 10 : A[i, j+1]
    return minimum([u, d, l, r])
end

function day9(f, part)
    heightmap = open(f) do file
        reduce(hcat, [collect(x) .- '0' for x in eachline(file)])
    end
    
    if part == 1
        return sum([(heightmap[ci] + 1) * (heightmap[ci] < min_neighbour(heightmap, ci)) for ci in CartesianIndices(heightmap)])
    end

    basins = label_components(heightmap .!= 9)
    return prod(partialsort!(component_lengths(basins), 2:4, rev = true))
end